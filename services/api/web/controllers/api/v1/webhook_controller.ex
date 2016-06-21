defmodule Pipelite.Api.V1.WebhookController do
  use Pipelite.Web, :controller
  alias Pipelite.WebhookHandler
  alias Buildkite

  plug :validate_webhook_token when action in [:buildkite]
  plug :validate_event_type when action in [:buildkite]

  @buildkite_supported_events ~w(
    build.scheduled
    build.running
    build.finished
    job.started
    job.finished
  )

  def buildkite(conn, params) do
    case handle_event(conn, params) do
      {:ok, _response} ->
        conn |> put_status(:ok) |> json(%{ok: true})
      {:error, reason} ->
        conn |> put_status(:unprocessable_entity) |> json(reason)
    end
  end

  defp handle_event(conn, params) do
    case event_type(conn) do
      "build.scheduled" -> WebhookHandler.Build.scheduled(params)
      "build.running"   -> WebhookHandler.Build.running(params)
      "build.finished"  -> WebhookHandler.Build.finished(params)
      "job.started"     -> WebhookHandler.Job.started(params)
      "job.finished"    -> WebhookHandler.Job.finished(params)
    end
  end

  defp valid_webhook_token?(conn), do: webhook_token(conn) == Buildkite.get_webhook_token!
  defp valid_event_type?(conn), do: Enum.member?(@buildkite_supported_events, event_type(conn))
  defp event_type(conn), do: hd(get_req_header(conn, "x-buildkite-event"))
  defp webhook_token(conn), do: hd(get_req_header(conn, "x-buildkite-token"))

  defp validate_webhook_token(conn, _params) do
    if valid_webhook_token?(conn) do
      conn
    else
      conn |> put_status(:unauthorized) |> json(%{error: "Buildkite webhook token is invalid."})
    end
  end

  defp validate_event_type(conn, _params) do
    if valid_event_type?(conn) do
      conn
    else
      conn |> put_status(:unauthorized) |> json(%{error: "Buildkite event type is invalid."})
    end
  end
end
