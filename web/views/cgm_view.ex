defmodule ExDiagcare.CgmView do
  use ExDiagcare.Web, :view

  def index(conn, %{cgm_events: cgm_events}) do
    render conn, "index.html", cgm_events: cgm_events
  end
end
