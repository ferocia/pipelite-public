defmodule Pipelite.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :build_id, references(:builds), null: false
      add :type, :string, null: false
      add :name, :string, null: false
      add :state, :string, null: false
      add :remote_id, :string, null: false
      add :payload, :json, null: false

      timestamps
    end
    create index(:jobs, [:build_id])
    create index(:jobs, [:remote_id], unique: true)
  end
end
