defmodule ExDiagcare.CgmView do
  use ExDiagcare.Web, :view

  def events_with_index(cgm_events) do
    Enum.with_index(cgm_events)
  end
end
