defmodule Pipelite.Repo.Migrations.MakeActivityDataNullable do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      modify :data, :json, null: true
    end
  end
end
