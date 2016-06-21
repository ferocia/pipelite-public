defmodule Buildkite do
  def get_access_token! do
    case System.get_env("BUILDKITE_ACCESS_TOKEN") do
      nil   -> raise("Required environment var 'BUILDKITE_ACCESS_TOKEN' not set!")
      token -> token
    end
  end

  def get_webhook_token! do
    case System.get_env("BUILDKITE_WEBHOOK_TOKEN") do
      nil   -> raise("Required environment var 'BUILDKITE_WEBHOOK_TOKEN' not set!")
      token -> token
    end
  end
end
