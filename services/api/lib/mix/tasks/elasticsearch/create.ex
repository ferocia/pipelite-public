defmodule Mix.Tasks.Pipelite.Elasticsearch.Create do
  use Mix.Task
  require Tirexs.ElasticSearch
  alias Pipelite.Repo
  alias Pipelite.Log
  alias Pipelite.Elasticsearch.LogIndex

  @shortdoc "Create Elastic Search mappings and bulk insert log data. Using"

  def run(_) do
    Repo.start_link
    bootstrap_log_index
  end

  defp bootstrap_log_index do
    Mix.shell.info "Creating new logs index"
    {:ok, _, _} = LogIndex.create

    Mix.shell.info "Inserting log documents"
    Log
    |> Repo.all
    |> Enum.chunk(10)
    |> Enum.each(fn(records) ->
      LogIndex.insert(records)
      :timer.sleep(5000) # We are not playing with much RAM here! Give it a chance to catch up!
    end)
  end
end
