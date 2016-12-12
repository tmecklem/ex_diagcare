defmodule ExDiagcare.CgmPageView do
  use ExDiagcare.Web, :view

  def events_with_index(cgm_events) do
    Enum.with_index(cgm_events)
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
      {:data_end, _} ->
        "Data End"
      {:sensor_weak_signal, _} ->
        "Sensor Weak Signal"
      {:sensor_calibration, event_info} ->
        "Sensor Calibration #{event_info[:calibration_type]}"
      {:sensor_packet, event_info} ->
        "Sensor Packet [#{event_info[:packet_type]}]"
      {:sensor_error, event_info} ->
        "Sensor Error [#{event_info[:error_type]}]"
      {:sensor_data_low, data} ->
        "<i class=\"fa fa-tint\" aria-hidden=\"true\"></i> #{data.sgv} mg/dl Sensor Data Low"
      {:sensor_data_high, data} ->
        "<i class=\"fa fa-tint\" aria-hidden=\"true\"></i> #{data.sgv} mg/dl Sensor Data High"
      {:sensor_timestamp, event_info} ->
        "Sensor Timestamp [#{event_info[:event_type]}]"
      {:battery_change, _} ->
        "Battery Change"
      {:sensor_status, event_info} ->
        "Sensor Status [#{event_info[:status_type]}]"
      {:datetime_change, _} ->
        "Date/Time Change"
      {:sensor_sync, event_info} ->
        "Sensor Sync [#{event_info[:sync_type]}]"
      {:cal_bg_for_gh, data} ->
        "<i class=\"fa fa-tint\" aria-hidden=\"true\"></i> #{data[:amount]} mg/dl Cal BG For GH [#{data[:origin_type]}]"
      {:sensor_calibration_factor, data} ->
        "<i class=\"fa fa-circle\" aria-hidden=\"true\"></i> #{data[:factor]} Sensor Calibration Factor"
      {:ten_something, _} ->
        "Opcode 0x10"
      {:nineteen_something, _} ->
        "Opcode 0x13"
      {:sensor_glucose_value, data} ->
        "<i class=\"fa fa-tint\" aria-hidden=\"true\"></i> #{data.sgv} mg/dl"
      {:unknown, _} ->
        "Unknown"
      {:null_byte, _} ->
        "No Data"
      _ ->
        ""
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
    data.raw
    |> Base.encode16
    |> String.replace(~r/(.{2})(?=.)/, "\\1 \\2")
  end

  def event_size({event_type, _}) do
    case event_type do
      :data_end                  -> 2
      :sensor_weak_signal        -> 2
      :sensor_calibration        -> 2
      :sensor_packet             -> 2
      :sensor_error              -> 2
      :sensor_data_low           -> 2
      :sensor_data_high          -> 2
      :sensor_timestamp          -> 4
      :battery_change            -> 4
      :sensor_status             -> 4
      :datetime_change           -> 4
      :sensor_sync               -> 4
      :cal_bg_for_gh             -> 4
      :sensor_calibration_factor -> 4
      :ten_something             -> 4
      :nineteen_something        -> 2
      :sensor_glucose_value      -> 2
      :null_byte                 -> 2
      :unknown                   -> 2
      _                          -> 4
    end
  end
end
