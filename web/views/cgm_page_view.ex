defmodule ExDiagcare.CgmPageView do
  use ExDiagcare.Web, :view

  def events_with_index(cgm_events) do
    Enum.with_index(cgm_events)
  end

  def event_rows(events), do: event_rows(events, [[]])
  def event_rows([], rows), do: Enum.reverse(rows)
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
      {:sensor_glucose_value, data} ->
        "<i class=\"fa fa-tint\" aria-hidden=\"true\"></i> #{data.sgv} mg/dl"
      {:data_end, _} ->
        "Data End"
      {:unknown, _} ->
        "Unknown"
      {:null_byte, _} ->
        "No Data"
      {:ten_something, _} ->
        "Opcode 0x10"
      {:nineteen_something, _} ->
        "Opcode 0x13"
      {:sensor_status, _} ->
        "Sensor Status"
      {:sensor_sync, _} ->
        "Sensor Sync"
      {:sensor_calibration, _} ->
        "Sensor Calibration"
      {:sensor_weak_signal, _} ->
        "Sensor Weak Signal"
      {:fokko7, _} ->
        "Opcode 0x07"
      {:sensor_timestamp, _} ->
        "Sensor Timestamp"
      {:datetime_change, _} ->
        "Date/Time Change"
      {:battery_change, _} ->
        "Battery Change"
      {:sensor_calibration_factor, data} ->
        "<i class=\"fa fa-circle\" aria-hidden=\"true\"></i> #{data[:factor]} Sensor Calibration Factor"
      {:cal_bg_for_gh, data} ->
        "<i class=\"fa fa-tint\" aria-hidden=\"true\"></i> #{data[:amount]} mg/dl Cal BG For GH"
      _ ->
        ""
    end
  end

  def format_timestamp({_, %{timestamp: ts}}) do
    "<i class=\"fa fa-clock-o\" aria-hidden=\"true\"></i> " <>
      Timex.format!(ts, "%m/%d/%y %H:%M", :strftime)
  end

  def format_timestamp(_) do
    "No Timestamp"
  end

  def format_hex({_, data}) do
    data.raw
    |> Base.encode16
    |> String.replace(~r/(.{2})(?=.)/, "\\1 \\2")
  end

  def event_size({event_type, _}) do
    case event_type do
      :sensor_glucose_value -> 2
      :ten_something        -> 4
      :nineteen_something   -> 2
      :data_end             -> 2
      :null_byte            -> 2
      :unknown              -> 2
      :sensor_weak_signal   -> 2
      :sensor_calibration   -> 2
      :fokko7               -> 2
      _                     -> 4
    end
  end
end
