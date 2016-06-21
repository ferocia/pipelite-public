defmodule Pipelite.Project do
  use Pipelite.Web, :model

  schema "projects" do
    has_many :builds, Pipelite.Build
    has_many :activities, Pipelite.Activity

    field :name, :string
    field :slug, :string
    field :remote_id, :string
    field :payload, Pipelite.JSON

    timestamps
  end

  after_insert Pipelite.ActivityCreator, :create, []
  before_update Pipelite.ActivityCreator, :create, []

  @required_fields ~w(
    name
    payload
    remote_id
    slug
  )
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def ordered(query) do
    from project in query, order_by: [desc: project.inserted_at]
  end

  def with_preloaded_builds(q), do: from q, preload: [:builds]
end
