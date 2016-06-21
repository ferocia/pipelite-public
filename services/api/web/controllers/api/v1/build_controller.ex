defmodule Pipelite.Api.V1.BuildController do
  use Pipelite.Web, :controller
  alias Pipelite.Build
  alias Pipelite.Api.BuildFilters

  def index(conn, params) do
    builds = Build
    |> BuildFilters.filter_all(params)
    |> Build.with_ordered_desc
    |> Build.with_preloaded_project
    |> Repo.all

    render(conn, "index.json", builds: builds)
  end

  def show(conn, %{"id" => id}) do
    build = Build
    |> Build.with_preloaded_project
    |> Repo.get(id)

    render(conn, "show.json", build: build)
  end

  def recent(conn, _params) do
    builds = Build
    |> Build.with_ordered_desc
    |> Build.with_limit(20)
    |> Build.with_preloaded_project
    |> Repo.all

    render(conn, "index.json", builds: builds)
  end
end
