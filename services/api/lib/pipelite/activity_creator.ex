defmodule Pipelite.ActivityCreator do
  alias Pipelite.Repo
  require Logger

  def create(changeset) do
    changeset
    |> select_activity
    |> build_models(changeset)
    |> persist
    changeset
  end

  defp select_activity(changeset) do
    case get_reducer(changeset.model) do
      {:ok, reducer}   -> reducer.map(changeset)
      {:error, reason} -> {:error, reason}
    end
  end

  defp build_models(activities, changeset) do
    activities
    |> Enum.map(fn(x) -> build_model(changeset, x) end)
    |> Enum.filter(fn(x) -> x != nil end)
  end

  defp build_model(changeset, activity) do
    if activity do
      Ecto.Model.build(changeset.model, :activities, %{
        action: Atom.to_string(changeset.action),
        data: activity
      })
    end
  end

  defp persist(models) do
    Repo.transaction fn ->
      Enum.map(models, &Repo.insert!/1)
    end
  end

  defp get_reducer(model) do
    case model do
      %Pipelite.Build{}   -> {:ok, Pipelite.Activity.BuildActivitySelector}
      %Pipelite.Project{} -> {:ok, Pipelite.Activity.ProjectActivitySelector}
      _                   -> {:error, "Activity reducer does not exist for #{model}."}
    end
  end
end
