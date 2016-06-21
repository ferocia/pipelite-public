defmodule Pipelite.Repo.Migrations.CreateActivity do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :type, :string, null: false
      add :data, :json, null: false

      add :project_id, references(:projects), null: true
      add :build_id, references(:builds), null: true

      timestamps
    end
    create index(:activities, [:project_id, :build_id])
  end
end
