defmodule Pipelite.Api.V1.LogView do
  use Pipelite.Web, :view
  alias Pipelite.Api.V1.LogView

  @attributes ~w(
    body
    id
    inserted_at
    length
    updated_at
  )a

  def render("search.json", %{logs: logs}) do
    logs = logs
    |> Enum.map(fn(x) -> Map.get(x, :_source) end)
    render_many(logs, LogView, "log.json")
  end

  # TODO Drop the body from these?
  def render("index.json", %{logs: logs}) do
    render_many(logs, LogView, "log.json")
  end

  def render("search.json", %{logs: logs}) do
    render_many(logs, LogView, "log.json")
  end

  def render("show.json", %{log: log}) do
    render_one(log, LogView, "log.json")
  end

  def render("log.json", %{log: log}) do
    log |> Map.take(@attributes)
  end
end
