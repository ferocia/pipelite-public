defmodule Pipelite.Repo.Migrations.CreateBuild do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :project_id, references(:projects), null: false
      add :remote_id, :string, null: false
      add :branch, :string, null: false
      add :payload, :json, null: false
      add :state, :string, null: false

      timestamps
    end
    create index(:builds, [:project_id])
    create index(:builds, [:remote_id], unique: true)
    create index(:builds, [:branch])
  end
end
