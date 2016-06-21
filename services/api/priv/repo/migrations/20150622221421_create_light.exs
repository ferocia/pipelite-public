defmodule Pipelite.Repo.Migrations.CreateLight do
  use Ecto.Migration

  def change do
    create table(:lights) do
      add :uuid, :string
      add :label, :string
      add :project_id, references(:projects)

      timestamps
    end
    create index(:lights, [:project_id])
  end
end
