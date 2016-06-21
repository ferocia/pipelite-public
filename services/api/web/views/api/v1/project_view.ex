defmodule Pipelite.Api.V1.ProjectView do
  use Pipelite.Web, :view

  alias Pipelite.Api.V1.BuildView
  alias Pipelite.Api.V1.ProjectView

  @attributes ~w(
    id
    name
    slug
    inserted_at
    updated_at
    remote_id
  )a

  def render("index.json", %{projects: projects}) do
    render_many(projects, ProjectView, "project.json")
  end

  def render("show.json", %{project: project}) do
    render_one(project, ProjectView, "project.json")
  end

  def render("project.json", %{project: project}) do
    project
    |> Map.take(@attributes)
  end

  def render("project_for_build.json", %{build: build}) do
    build.project
    |> Map.take(@attributes)
  end
end
