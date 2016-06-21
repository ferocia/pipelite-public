defmodule Pipelite.Repo.Migrations.RefactorActivityFields do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :object, :string, null: true
    end

    rename table(:activities), :type, to: :action
    create index(:activities, [:project_id])
    create index(:activities, [:build_id])
  end
end
