defmodule Pipelite.Api.V1.LogController do
  use Pipelite.Web, :controller
  alias Pipelite.Log
  import Tirexs.Search
  require Tirexs.Query
  alias Pipelite.Elasticsearch
  alias Pipelite.Elasticsearch.LogIndex

  def index(conn, %{"search" => search}) do
    logs = search([index: LogIndex.index]) do
      query do
        string "body:" <> search
      end
    end
    case Tirexs.Query.create_resource(logs, Elasticsearch.settings) do
      {:error, _, _} ->
        conn |> put_status(400) |> json(%{message: "Invalid search query."})
      result = _ ->
        logs = Tirexs.Query.result(result, :hits)
        render(conn, "search.json", logs: logs)
    end
  end

  def index(conn, _params) do
    render(conn, "index.json", logs: Repo.all(Log))
  end

  def show(conn, %{"id" => id}) do
    log = Log
    |> Repo.get(id)

    render(conn, "show.json", log: log)
  end
end
