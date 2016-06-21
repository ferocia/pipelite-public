defmodule Pipelite.HealthController do
  use Pipelite.Web, :controller

  def index(conn, _params) do
    json conn, %{current_migration: current_migration}
  end

  defp current_migration do
    case Ecto.Adapters.SQL.query(Repo, "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;", []) do
      {:ok, query} -> query |> Dict.get(:rows) |> List.flatten |> List.first
    end
  end
end
