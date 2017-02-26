defmodule ExDiagcare.HistoryPageView do
  use ExDiagcare.Web, :view

  def events_with_index(history_events) do
    Enum.with_index(history_events)
  end

  def event_rows(events), do: event_rows(events, [[]])
  def event_rows([], [row | tail]), do: Enum.reverse([Enum.reverse(row) | tail])
  def event_rows([event | rest], [row | tail]) do
    current_row_size = event_size(event) + Enum.reduce(row, 0, fn (event, acc) -> acc + event_size(event) end)
    cond do
      current_row_size > 12 -> event_rows(rest, [[event] | [Enum.reverse(row) | tail]])
      true                  -> event_rows(rest, [[event | row] | tail])
    end
  end

  def event_type({event_type, _}), do: event_type

  def format_event_info(event) do
    case event do
      {:null_byte, _} ->
        "No Data"
      {event_type, event_info} ->
        "#{event_type}"
    end
  end

  def format_timestamp({_, %{timestamp: nil}}), do: ""
  def format_timestamp({_, %{timestamp: ts}}) do
    "<i class=\"fa fa-clock-o\" aria-hidden=\"true\"></i> " <>
      Timex.format!(ts, "%m/%d/%y %H:%M", :strftime)
  end

  def format_timestamp(_) do
    "No Timestamp"
  end

  def format_hex({_, data}) do
    data[:raw]
    |> Base.encode16
    |> String.replace(~r/(.{2})(?=.)/, "\\1 \\2")
  end

  def event_size({event_type, _}) do
    case event_type do
      _                          -> 4
    end
  end
end
