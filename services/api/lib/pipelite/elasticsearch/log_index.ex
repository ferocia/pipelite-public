defmodule Pipelite.Elasticsearch.LogIndex do
  import Tirexs.Bulk
  import Tirexs.Mapping
  require Tirexs.ElasticSearch
  require Tirexs.Query
  alias Pipelite.Repo
  alias Pipelite.Elasticsearch
  alias Pipelite.Job

  def index, do: "logs"
  def type, do: "log"

  def create do
    index = [index: index, type: type]
    mappings do
      indexes "id", type: "long", index: "not_analyzed"
      indexes "body", type: "string", analyzer: "snowball"
      indexes "job", type: "object" do
        indexes "id", type: "long", index: "not_analyzed"
        indexes "type", type: "string"
        indexes "name", type: "string"
        indexes "state", type: "string"
      end
    end

    {:ok, _status, _body} = Tirexs.Mapping.create_resource(index, Elasticsearch.settings)
  end

  def insert(changesets) when is_list(changesets) do
    if Enum.count(changesets) > 0 do
      {:ok, _status, _body} = Tirexs.Bulk.store([index: index, refresh: true], Elasticsearch.settings) do
        changesets
        |> Enum.flat_map(fn(log) -> [create: to_indexable(log)] end)
      end
    end
    changesets
  end

  def insert(changeset = %Ecto.Changeset{action: :insert, changes: changes}) do
    {:ok, _status, _body} = Tirexs.Bulk.store([index: index, refresh: true], Elasticsearch.settings) do
      [create: to_indexable(changes)]
    end
    changeset
  end

  @doc """
  Convert a Log into fields for creating an entry in the Elasticsearch Logs index.
  """
  def to_indexable(log) do
    [
      id: log.id,
      body: log.body,
      job: Map.take(Repo.get!(Job, log.job_id), [:id, :type, :name, :state]),
      type: type
    ]
  end
end
