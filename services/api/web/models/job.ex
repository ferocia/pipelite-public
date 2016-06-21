defmodule Pipelite.Job do
  use Pipelite.Web, :model

  schema "jobs" do
    belongs_to :build, Pipelite.Build

    field :type, :string
    field :name, :string
    field :remote_id, :string
    field :state, :string
    field :payload, Pipelite.JSON

    timestamps
  end

  @required_fields ~w(
    type
    name
    state
    remote_id
    payload
  )
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def log_url(model) do
    get_in(model.payload, ["log_url"])
  end

  def raw_log_url(model) do
    get_in(model.payload, ["raw_log_url"])
  end
end
