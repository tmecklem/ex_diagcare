defmodule ExDiagcare.Repo.Migrations.CreateCgmPage do
  use Ecto.Migration

  def change do
    create table(:cgm_pages) do
      add :page_hash, :string, null: false
      add :page_data, :binary, null: false

      timestamps
    end

    create unique_index(:cgm_pages, [:page_hash])
  end
end
