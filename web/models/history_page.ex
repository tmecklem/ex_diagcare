defmodule ExDiagcare.HistoryPage do
  use ExDiagcare.Web, :model

  schema "history_pages" do
    field :page_hash, :string
    field :page_data, :binary
    field :pump_model, :string

    timestamps
  end
end
