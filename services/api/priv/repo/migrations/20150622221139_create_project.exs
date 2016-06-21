defmodule Pipelite.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :remote_id, :string, null: false
      add :name, :string, null: false
      add :slug, :string, null: false
      add :payload, :json, null: false

      timestamps
    end
    create index(:projects, [:remote_id], unique: true)
  end
end
