defmodule Pipelite.Activity do
  use Pipelite.Web, :model

  schema "activities" do
    field :action, :string
    field :data, Pipelite.JSON

    belongs_to :project, Pipelite.Project
    belongs_to :build, Pipelite.Build

    timestamps
  end

  @required_fields ~w(action)
  @optional_fields ~w(data)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def ordered(q), do: from activity in q, order_by: [desc: activity.inserted_at]
end
