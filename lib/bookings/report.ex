defmodule Flightex.Bookings.Report do
  @moduledoc """
  Flight Bookings Report.
  """

  alias Flightex.Bookings.Agent

  def build(from_date, to_date, file_name \\ "report.csv") do
    bookings_string_list =
      from_date
      |> Agent.get_all_by_date(to_date)
      |> Enum.map(fn booking_map -> map_to_string_list(booking_map) end)

    File.write!(file_name, bookings_string_list)

    {:ok, "Report generated succesfully"}
  end

  def map_to_string_list(%{
        complete_date: complete_date,
        local_destination: local_destination,
        local_origin: local_origin,
        user_id: user_id
      }) do
    [user_id, local_origin, local_destination, "#{complete_date}\n"]
    |> Enum.join(",")
  end
end
