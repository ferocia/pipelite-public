defmodule Pipelite.Api.V1.ProjectController do
  use Pipelite.Web, :controller

  alias Pipelite.Project

  plug :scrub_params, "project" when action in [:create, :update]

  def index(conn, _params) do
    projects = Project
    |> Project.ordered
    |> Repo.all
    render(conn, "index.json", projects: projects)
  end

  def show(conn, %{"id" => slug}) do
    project = Project
    |> Repo.get_by!(slug: slug)

    render conn, "show.json", project: project
  end
end
