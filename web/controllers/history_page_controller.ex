defmodule ExDiagcare.HistoryPageController do
  use ExDiagcare.Web, :controller
  alias ExDiagcare.HistoryPage
  alias Pummpcomm.History
  alias Pummpcomm.PumpModel

  def index(conn, %{"ids" => ids}) do
    history_events = ids
    |> Enum.map(fn(id) -> Repo.get_by(HistoryPage, page_hash: id) end)
    |> Enum.reduce([], &(accumulate_events(&1, &2)))

    render conn, "decode_history.html", history_events: history_events
  end

  def index(conn, _params), do: redirect conn, to: history_page_path(conn, :new)

  def new(conn, _params), do: render conn, "new.html"

  def create(conn, %{"page_file" => page_file, "pump_model" => pump_model}) do
    {:ok, page_data} = File.read(page_file.path)
    page_hash = :crypto.hash(:sha, page_data) |> Base.encode16
    {:ok, history_page} = Repo.insert(%HistoryPage{page_data: page_data, page_hash: page_hash, pump_model: pump_model})
    redirect conn, to: history_page_path(conn, :show, history_page.page_hash)
  end

  def show(conn, %{"id" => page_hash}) do
    history_page = Repo.get_by(HistoryPage, page_hash: page_hash)
    {:ok, model_number} = PumpModel.model_number(history_page.pump_model)
    {:ok, history_events} = History.decode(history_page.page_data, model_number)
    render conn, "decode_history.html", history_events: history_events
  end

  defp accumulate_events(history_page, events) do
    {:ok, model_number} = PumpModel.model_number(history_page.pump_model)
    {:ok, history_events} = History.decode(history_page.page_data, model_number)
    events ++ history_events
  end
end
