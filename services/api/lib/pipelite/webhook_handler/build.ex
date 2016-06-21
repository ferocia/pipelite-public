defmodule Pipelite.WebhookHandler.Build do
  import Pipelite.WebhookHandler
  alias Pipelite.Repo
  alias Ecto.Changeset
  alias Pipelite.Buildlight

  def scheduled(params), do: handle_build(params)
  def running(params),   do: handle_build(params)
  def finished(params),  do: handle_build(params)

  defp handle_build(params) do
    {project, project_ctx} = create_project_changeset(params)
    {build, build_ctx} = create_build_changeset(params)

    cond do
      !project_ctx.valid? -> {:error, project_ctx}
      !build_ctx.valid?   -> {:error, build_ctx}
      true ->
        Repo.transaction fn ->
          project = Repo.upsert!(project, project_ctx)
          build = Repo.upsert!(build, Changeset.change(build_ctx, project_id: project.id))
          if build.branch == "master" do
            Buildlight.set!(project, build.state)
          end
          broadcast_state(build)
          %{project: project, build: build}
        end
    end
  end

  defp broadcast_state(build) do
    build = Repo.preload(build, :project)

    Pipelite.Endpoint.broadcast!("state", "state", %{
      build: Pipelite.Api.V1.BuildView.render("show.json", build: build)
    })
  end
end
