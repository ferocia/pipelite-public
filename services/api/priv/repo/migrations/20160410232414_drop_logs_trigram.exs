defmodule Pipelite.Repo.Migrations.DropLogsTrigram do
  use Ecto.Migration

  def change do
    execute "DROP INDEX logs_body_trgm_index;"
    execute "DROP extension pg_trgm;"
  end
end
