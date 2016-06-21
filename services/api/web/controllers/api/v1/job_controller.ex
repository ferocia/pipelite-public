defmodule Pipelite.Api.V1.JobController do
  use Pipelite.Web, :controller
  alias Pipelite.Job

  def index(conn, _params) do
    jobs = Job |> Repo.all

    render(conn, "index.json", jobs: jobs)
  end
end
