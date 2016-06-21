defmodule Buildkite.Api do
  use HTTPoison.Base
  require Logger

  @url "https://api.buildkite.com"
  @version "v1"

  defp process_url(url) do
    @url <> url
  end

  defp process_request_headers(headers) do
    headers ++ [
      {"Authorization", "Bearer #{Buildkite.access_token}"},
      {"Host", :undefined}
    ]
  end
end
