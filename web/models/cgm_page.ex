defmodule ExDiagcare.CgmPage do
  use ExDiagcare.Web, :model

  schema "cgm_pages" do
    field :page_hash, :string
    field :page_data, :binary

    timestamps
  end
end
