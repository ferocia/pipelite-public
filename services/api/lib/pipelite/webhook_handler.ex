defmodule Pipelite.WebhookHandler do
  alias Pipelite.Repo
  alias Pipelite.Build
  alias Pipelite.Project
  alias Pipelite.Job
  alias Ecto.Changeset

  def create_project_changeset(params) do
    project = Repo.get_by(Project, remote_id: get_in(params, ["project", "id"]))
    changeset = Project.changeset(project || %Project{}, filter_project_params(get_in(params, ["project"])))
    {project, changeset}
  end

  def create_build_changeset(params) do
    build = Repo.get_by(Build, remote_id: get_in(params, ["build", "id"]))
    changeset = Build.changeset(build || %Build{}, filter_build_params(get_in(params, ["build"])))
    {build, changeset}
  end

  def create_job_changeset(params) do
    job = Repo.get_by(Job, remote_id: get_in(params, ["job", "id"]))
    changeset = Job.changeset(job || %Job{}, filter_job_params(get_in(params, ["job"])))
    {job, changeset}
  end

  defp filter_build_params(params) do
    params
    |> Dict.take(["number", "state", "message", "commit", "branch"])
    |> Dict.put("payload", params)
    |> Dict.put("remote_id", Dict.get(params, "id"))
  end

  defp filter_project_params(params) do
    params
    |> Dict.take(["name", "slug"])
    |> Dict.put("payload", params)
    |> Dict.put("remote_id", Dict.get(params, "id"))
  end

  defp filter_job_params(params) do
    params
    |> Dict.take(["type", "name", "state"])
    |> Dict.put("payload", params)
    |> Dict.put("remote_id", Dict.get(params, "id"))
  end
end
