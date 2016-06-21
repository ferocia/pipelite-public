defmodule Pipelite.Api.V1.ActivityController do
  use Pipelite.Web, :controller

  alias Pipelite.Activity

  def index(conn, _params) do
    activities = Activity |> Activity.ordered |> Repo.all
    render(conn, "index.json", activities: activities)
  end

  def show(conn, %{"id" => id}) do
    activity = Repo.get(Activity, id)
    render conn, "show.json", activity: activity
  end
end
