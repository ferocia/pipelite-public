defmodule Pipelite.Repo.Migrations.UniqueProjectSlug do
  use Ecto.Migration

  def change do
    create index(:projects, [:slug], unique: true)
  end
end
