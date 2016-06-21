defmodule Pipelite.Log do
  use Pipelite.Web, :model

  schema "logs" do
    belongs_to :job, Pipelite.Job
    field :body, :string
    field :length, :integer

    timestamps
  end

  after_insert Pipelite.Elasticsearch.LogIndex, :insert, []

  @required_fields ~w(body length)
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

  def with_preloaded_job(q), do: from q, preload: [:job]
end
