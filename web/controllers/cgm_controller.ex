defmodule ExDiagcare.CgmPageController do
  use ExDiagcare.Web, :controller
  alias ExDiagcare.CgmPage
  alias Decocare.Cgm

  def index(conn, %{"ids" => ids}) do
    cgm_events = ids
    |> Enum.map(fn(id) -> Repo.get_by(CgmPage, page_hash: id) end)
    |> Enum.reduce([], &(accumulate_events(&1, &2)))

    render conn, "decode_cgm.html", cgm_events: cgm_events
  end

  def index(conn, _params), do: redirect conn, to: cgm_page_path(conn, :new)

  def new(conn, _params), do: render conn, "new.html"

  def create(conn, %{"page_file" => page_file}) do
    {:ok, page_data} = File.read(page_file.path)
    page_hash = :crypto.hash(:sha, page_data) |> Base.encode16
    {:ok, cgm_page} = Repo.insert(%CgmPage{page_data: page_data, page_hash: page_hash})
    redirect conn, to: cgm_page_path(conn, :show, cgm_page.page_hash)
  end

  def show(conn, %{"id" => page_hash}) do
    cgm_page = Repo.get_by(CgmPage, page_hash: page_hash)
    {:ok, cgm_events} = Cgm.decode(cgm_page.page_data)
    render conn, "decode_cgm.html", cgm_events: cgm_events
  end

  defp accumulate_events(cgm_page, events) do
    {:ok, cgm_events} = Cgm.decode(cgm_page.page_data)
    events ++ cgm_events
  end
end
