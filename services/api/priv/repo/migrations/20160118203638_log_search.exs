defmodule Pipelite.Repo.Migrations.LogSearch do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX logs_body_trgm_index ON logs USING gin (body gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX logs_body_trgm_index;"
  end
end
