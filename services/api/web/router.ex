defmodule Pipelite.Router do
  use Pipelite.Web, :router
  if Mix.env == :prod, do: use ExSentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  get "/health", Pipelite.HealthController, :index

  scope "/api", Pipelite.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      post "/webhook/buildkite", WebhookController, :buildkite

      scope "/activities" do
        resources "/", ActivityController
      end

      scope "/projects" do
        resources "/", ProjectController
      end

      scope "/builds" do
        get "/recent", BuildController, :recent
        resources "/", BuildController
      end

      scope "/jobs" do
        resources "/", JobController
      end

      scope "/logs" do
        resources "/", LogController
      end

      scope "/charts" do
        resources "/", ChartController
      end
    end
  end
end
