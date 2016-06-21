defmodule LifxAPI do
  @moduledoc """
  Responsible for providing a basic interface to the LIFX HTTP API.
  """

  use HTTPoison.Base
  require Logger

  @api_version "v1beta1"

  def lights(selector) do
    "/#{@api_version}/lights/#{format_selector selector}"
    |> URI.encode
    |> get!
    |> handle_response
  end

  def breathe(selector, params) do
    "/#{@api_version}/lights/#{format_selector selector}/effects/breathe"
    |> URI.encode
    |> post!(Poison.encode!(params), [{"Content-type", "application/json"}])
    |> handle_response
  end

  defp handle_response(response) do
    cond do
      response.status_code in 200..299 ->
        {:ok, response.body}
      response.status_code in 400..499 ->
        handle_failure_response(response)
      %HTTPoison.Response{body: %{"error" => _}} = response ->
        {:error, response.body["error"]}
      %HTTPoison.Error{reason: _} = response ->
        {:error, response.reason}
    end
  end

  defp handle_failure_response(response) do
    case response.body do
      %{"status" => "offline", "id" => light_id} ->
        {:error, "light (#{light_id}) is currently offline."}
      %{"message" => "Token required"} ->
        {:error, "Lifx access token is not set - please set 'LIFX_ACCESS_TOKEN'."}
      %{"message" => reason} ->
        {:error, reason}
    end
  end

  defp process_url(url) do
    "https://api.lifx.com" <> url
  end

  defp process_response_body(body) do
    body |> Poison.decode!
  end

  defp process_request_headers(headers) do
    headers ++ [
      {"Authorization", "Bearer #{authorization}"},
      {"Host", :undefined}
    ]
  end

  defp format_selector(selector) do
    case selector do
      {:group, group}             -> "group:#{group}"
      {:label, label}             -> "label:#{label}"
      {:id, id}                   -> "id:#{id}"
      {:group_id, group_id}       -> "group_id:#{group_id}"
      {:location_id, location_id} -> "location_id:#{location_id}"
      {:location, location}       -> "location:#{location}"
      :all                        -> selector
    end
  end

  defp authorization do
    # TODO: move this out into an application level module with all other ENV vars?
    System.get_env("LIFX_ACCESS_TOKEN")
  end
end
