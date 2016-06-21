defmodule Mix.Tasks.Pipelite.Elasticsearch.Delete do
  use Mix.Task
  require Tirexs.ElasticSearch
  alias Pipelite.Elasticsearch

  @shortdoc "Delete all Elastic Search indexes."

  def run(_) do
    Tirexs.ElasticSearch.delete("logs", Elasticsearch.settings)
  end
end
