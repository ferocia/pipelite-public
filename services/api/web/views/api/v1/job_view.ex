defmodule Pipelite.Api.V1.JobView do
  use Pipelite.Web, :view
  alias Pipelite.Api.V1.JobView

  @attributes ~w(
    id
    inserted_at
    name
    remote_id
    state
    type
    updated_at
  )a

  def render("index.json", %{jobs: jobs}) do
    render_many(jobs, JobView, "job.json")
  end

  def render("show.json", %{job: job}) do
    render_one(job, JobView, "job.json")
  end

  def render("job.json", %{job: job}) do
    job |> Map.take(@attributes)
  end
end
