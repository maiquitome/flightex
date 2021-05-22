defmodule Flightex.Bookings.Agent do
  @moduledoc false

  use Agent

  alias Flightex.Bookings.Booking

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    Agent.update(__MODULE__, fn state -> update_booking(state, booking) end)

    {:ok, id}
  end

  def get(booking_id) do
    Agent.get(__MODULE__, fn state -> get_booking(state, booking_id) end)
  end

  @doc """
  Get all flight bookings.

  ## Examples

      iex> Flightex.Bookings.Agent.get_all
      %{
        "0c440113-e49d-4503-89d4-b3cb35cb909f" => %Flightex.Bookings.Booking{
          complete_date: ~N[2023-01-01 00:00:00],
          id: "0c440113-e49d-4503-89d4-b3cb35cb909f",
          local_destination: "São Paulo",
          local_origin: "Porto Algre",
          user_id: "1899a5d7-554b-430d-88c9-eba35ada588b"
        },
        "9fdfd40d-9e72-486d-8783-b16be1cf56ec" => %Flightex.Bookings.Booking{
          complete_date: ~N[2022-05-13 00:00:00],
          id: "9fdfd40d-9e72-486d-8783-b16be1cf56ec",
          local_destination: "São Paulo",
          local_origin: "Porto Algre",
          user_id: "1899a5d7-554b-430d-88c9-eba35ada588b"
        },
        "dd570193-49a5-4c88-a602-e6169ef26738" => %Flightex.Bookings.Booking{
          complete_date: ~N[2022-12-12 00:00:00],
          id: "dd570193-49a5-4c88-a602-e6169ef26738",
          local_destination: "São Paulo",
          local_origin: "Porto Algre",
          user_id: "1899a5d7-554b-430d-88c9-eba35ada588b"
        }
      }

  """
  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Get all flight bookings filtering by date.

  ## Examples

      iex> Flightex.Bookings.Agent.get_all_by_date("01/01/2020", "30/12/2022")
      [
        %Flightex.Bookings.Booking{
          complete_date: ~N[2022-05-13 00:00:00],
          id: "9fdfd40d-9e72-486d-8783-b16be1cf56ec",
          local_destination: "São Paulo",
          local_origin: "Porto Algre",
          user_id: "1899a5d7-554b-430d-88c9-eba35ada588b"
        },
        %Flightex.Bookings.Booking{
          complete_date: ~N[2022-12-12 00:00:00],
          id: "dd570193-49a5-4c88-a602-e6169ef26738",
          local_destination: "São Paulo",
          local_origin: "Porto Algre",
          user_id: "1899a5d7-554b-430d-88c9-eba35ada588b"
        }
      ]

  """
  def get_all_by_date(from_date, to_date) do
    Agent.get(__MODULE__, fn bookings -> filter_dates(bookings, from_date, to_date) end)
  end

  defp filter_dates(%{} = bookings, from_date, to_date) do
    from_date = string_to_date(from_date)
    to_date = string_to_date(to_date)

    bookings
    |> Map.values()
    |> Enum.filter(fn booking -> compare_dates(booking.complete_date, from_date, to_date) end)
  end

  defp compare_dates(booking_date, from_date, to_date) do
    booking_date = NaiveDateTime.to_date(booking_date)

    from_date
    |> Date.range(to_date)
    |> Enum.member?(booking_date)
  end

  defp string_to_date(string_date) do
    [day, month, year] = String.split(string_date, "/", trim: true)

    year = String.to_integer(year)
    month = String.to_integer(month)
    day = String.to_integer(day)

    {:ok, date} = Date.new(year, month, day)

    date
  end

  # from_date 01/01/2022

  # booking.complete_date = 13/05/2022

  # to_date 30/12/2023

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
