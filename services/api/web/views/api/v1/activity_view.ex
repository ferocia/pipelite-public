defmodule Pipelite.Api.V1.ActivityView do
  use Pipelite.Web, :view

  @attributes ~w(
    action
    build_id
    data
    id
    inserted_at
    project_id
    updated_at
  )a

  def render("index.json", %{activities: activities}) do
    %{activities: render_many(activities, Pipelite.Api.V1.ActivityView, "activity.json")}
  end

  def render("show.json", %{activity: activity}) do
    render_one(activity, Pipelite.Api.V1.ActivityView, "activity.json")
  end

  def render("activity.json", %{activity: activity}) do
    activity
    |> Map.take(@attributes)
  end
end
