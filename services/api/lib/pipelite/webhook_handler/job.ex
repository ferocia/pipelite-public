defmodule Pipelite.WebhookHandler.Job do
  import Pipelite.WebhookHandler
  alias Pipelite.Repo
  alias Ecto.Changeset
  alias Buildkite.LogDownloader

  def started(params), do: handle_job(params)

  def finished(params) do
    case handle_job(params) do
      {:ok, response} ->
        # if the job is finished, and it failed then we should fire off a request
        # for the logs immediately so that we can process and present them for
        # inspection.
        if response.job.state == "failed" do
          LogDownloader.download!(response.job)
        end
        {:ok, response}
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_job(params) do
    {project, project_ctx} = create_project_changeset(params)
    {build, build_ctx} = create_build_changeset(params)
    {job, job_ctx} = create_job_changeset(params)

    cond do
      !project_ctx.valid? -> {:error, project_ctx}
      !build_ctx.valid?   -> {:error, build_ctx}
      !job_ctx.valid?     -> {:error, job_ctx}
      true                ->
        Repo.transaction fn ->
          project = Repo.upsert!(project, project_ctx)
          build = Repo.upsert!(build, Changeset.change(build_ctx, project_id: project.id))
          job = Repo.upsert!(job, Changeset.change(job_ctx, build_id: build.id))
          broadcast_state(project, build, job)
          %{project: project, build: build, job: job}
        end
    end
  end

  defp broadcast_state(project, build, job) do
    # Pipelite.Endpoint.broadcast!("state", "state", %{
    #   projects: Pipelite.Api.V1.ProjectView.render("show.json", project: project),
    #   builds: Pipelite.Api.V1.BuildView.render("show.json", build: build),
    #   job: Pipelite.Api.V1.JobView.render("show.json", job: job)
    # })
  end
end
