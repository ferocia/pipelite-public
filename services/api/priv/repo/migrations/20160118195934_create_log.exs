defmodule Pipelite.Repo.Migrations.CreateLog do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :job_id, references(:jobs), null: false
      add :body, :text, null: false
      add :length, :integer, null: false

      timestamps
    end
    create index(:logs, [:job_id])
  end
end
