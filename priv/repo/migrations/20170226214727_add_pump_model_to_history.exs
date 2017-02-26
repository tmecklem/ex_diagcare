defmodule ExDiagcare.Repo.Migrations.AddPumpModelToHistory do
  use Ecto.Migration

  def change do
    alter table(:history_pages) do
      add :pump_model, :string, null: false
    end
  end
end
