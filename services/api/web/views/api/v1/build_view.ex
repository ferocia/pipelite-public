defmodule Pipelite.Api.V1.BuildView do
  use Pipelite.Web, :view

  alias Pipelite.Api.V1.BuildView
  alias Pipelite.Api.V1.ProjectView

  @attributes ~w(
    branch
    id
    state
    inserted_at
    updated_at
    remote_id
    commit
    commit_short
    message
    creator
  )a

  @dynamic_attributes ~w(
    commit
    commit_short
    message
    creator
  )

  def render("index.json", %{builds: builds}) do
    render_many(builds, BuildView, "build.json")
  end

  def render("show.json", %{build: build}) do
    render_one(build, BuildView, "build.json")
  end

  def render("build.json", %{build: build}) do
    build
    |> with_dynamic_attributes
    |> Map.take(@attributes)
    |> Map.put(:project, ProjectView.render("project_for_build.json", build: build))
  end

  def render("builds_for_project.json", %{builds: builds}) do
    render_many(builds, BuildView, "build_for_project.json")
  end

  def render("build_for_project.json", %{build: build}) do
    build
    |> Map.take(@attributes)
  end

  defp with_dynamic_attributes(build) do
    @dynamic_attributes
    |> Enum.map(fn(x) -> {String.to_atom(x), apply(Pipelite.Build, String.to_atom(x), [build])} end)
    |> Map.new
    |> Map.merge(build)
  end
end
