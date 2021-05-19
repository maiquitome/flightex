defmodule Flightex.Bookings.Agent do
  @moduledoc false

  use Agent

  alias Flightex.Bookings.Booking

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def save(booking) do
    Agent.update(__MODULE__, fn state -> update_booking(state, booking) end)
  end

  def get(booking_id) do
    Agent.get(__MODULE__, fn state -> get_booking(state, booking_id) end)
  end

  defp update_booking(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end

  defp get_booking(state, booking_id) do
    case Map.get(state, booking_id) do
      nil -> {:error, "Flight Booking not found!"}
      booking -> {:ok, booking}
    end
  end
end
