defmodule ExDiagcare.Repo.Migrations.AddHistoryPages do
  use Ecto.Migration

  def change do
    create table(:history_pages) do
      add :page_hash, :string, null: false
      add :page_data, :binary, null: false

      timestamps
    end

    create unique_index(:history_pages, [:page_hash])
  end
end

