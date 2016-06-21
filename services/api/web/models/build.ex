defmodule Pipelite.Build do
  use Pipelite.Web, :model

  schema "builds" do
    belongs_to :project, Pipelite.Project
    has_many :activities, Pipelite.Activity

    field :branch, :string
    field :remote_id, :string
    field :state, :string
    field :payload, Pipelite.JSON

    timestamps
  end

  before_insert Pipelite.ActivityCreator, :create, []
  before_update Pipelite.ActivityCreator, :create, []

  @required_fields ~w(
    branch
    remote_id
    state
    payload
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

  def message(model) do
    get_in(model.payload, ["message"])
  end

  def commit(model) do
    get_in(model.payload, ["commit"])
  end

  def commit_short(model) do
    String.slice(commit(model), 0..6)
  end

  def creator(model) do
    get_in(model.payload, ["creator"])
  end

  def find_by_project_id(q, project_id) do
    from c in q, join: p in assoc(c, :project), where: p.id == ^project_id
  end

  def find_by_branch(q, ""), do: q
  def find_by_branch(q, branch) do
    from build in q, where: build.branch == ^branch
  end

  def find_by_state(q, ""), do: q
  def find_by_state(q, state) do
    from build in q, where: build.state == ^state
  end

  def find_by_created_after_date(q, ""), do: q
  def find_by_created_after_date(q, date) do
    case Ecto.Date.cast(date) do
      {:ok, date} ->
        datetime = Ecto.DateTime.from_date(date)
        from build in q, where: build.inserted_at >= ^datetime
      _ ->
        {:error, "Invalid Date format."}
    end
  end

  def find_by_updated_before_date(q, ""), do: q
  def find_by_updated_before_date(q, date) do
    case Ecto.Date.cast(date) do
      {:ok, date} ->
        datetime = Ecto.DateTime.from_date(date)
        from build in q, where: build.updated_at >= ^datetime
      _ ->
        {:error, "Invalid Date format."}
    end
  end

  def find_completed(q) do
    from build in q, where: build.state in ~w(passed failed)
  end

  def with_limit(q, size), do: from q, limit: ^size
  def with_ordered_desc(q), do: from build in q, order_by: [desc: build.inserted_at]
  def with_ordered_asc(q), do: from build in q, order_by: [asc: build.inserted_at]

  def with_preloaded_project(q), do: from q, preload: [:project]

  def find_by_created_in_n_days(q, n) do
    date = Timex.Date.subtract(Timex.Date.now, Timex.Time.to_timestamp(n, :days))
    find_by_created_after_date(q, date)
  end
end
