defmodule Buildkite.LogDownloader.Worker do
  use GenServer
  require Logger
  alias Pipelite.Repo
  alias Pipelite.Job
  alias Pipelite.Log
  alias Pipelite.Elasticsearch.LogIndex

  def start_link([]), do: GenServer.start_link(__MODULE__, [], [])
  def init(state), do: {:ok, state}

  def handle_call({:download!, job}, _, state) do
    case get_log!(job) do
      {:ok, body} ->
        log = Repo.insert!(%Log{body: body, length: byte_size(body), job_id: job.id})
        {:reply, {:ok, log}, state}
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  defp get_log!(job) do
    ExSentry.capture_exceptions fn ->
      HTTPoison.start
      HTTPoison.get!(Job.raw_log_url(job), request_headers) |> handle_response
    end
  end

  defp handle_response(response) do
    cond do
      response.status_code in 200..299 ->
        {:ok, response.body}
      %HTTPoison.Response{body: %{"error" => _}} = response ->
        {:error, response.body["error"]}
      %HTTPoison.Error{reason: _} = response ->
        {:error, response.reason}
    end
  end

  defp request_headers do
    [{"Authorization", "Bearer #{Buildkite.get_access_token!}"}]
  end
end
