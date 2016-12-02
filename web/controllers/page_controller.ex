defmodule ExDiagcare.PageController do
  use ExDiagcare.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
