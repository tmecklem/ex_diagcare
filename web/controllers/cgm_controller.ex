defmodule ExDiagcare.CgmController do
  use ExDiagcare.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def decode_cgm(conn, params) do
    IO.inspect params
    {:ok, cgm_page} = File.read(params["cgm"]["page"].path)
    {:ok, cgm_events} = Cgm.decode(cgm_page)
    render conn, "decode_cgm.html", cgm_events: cgm_events
  end
end
