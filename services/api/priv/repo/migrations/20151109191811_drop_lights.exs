defmodule Pipelite.Repo.Migrations.DropLights do
  use Ecto.Migration

  def change do
    drop table(:lights)
  end
end
