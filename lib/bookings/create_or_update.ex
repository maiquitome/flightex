defmodule Flightex.Bookings.CreateOrUpdate do
  @moduledoc false

  alias Flightex.Bookings.Agent
  alias Flightex.Bookings.Booking

  @doc """
  Create a flight booking for a user and save it in the agent.

  ## Examples

  - the user agent and booking agent must have been initialized

          iex> Flightex.initial_agents

  - creating the user:

        iex> {:ok, %{id: user_uuid} = user} = Flightex.Users.User.build("Maiqui", "maiquitome@gmail.com", "011.123.012-26")

  - creating the book

        iex> booking_params = %{complete_date: "13/05/2022", local_origin: "Porto Algre", local_destination: "São Paulo"}
        %{
          complete_date: "13/05/2022",
          local_destination: "São Paulo",
          local_origin: "Porto Algre"
        }

        iex> {:ok, booking_id} = Flightex.Bookings.CreateOrUpdate.call(user_uuid, booking_params)

  """
  def call(user_uuid, %{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination
      }) do
    complete_date
    |> Booking.build(local_origin, local_destination, user_uuid)
    |> save_booking()
  end

  defp save_booking({:ok, %Booking{id: id} = booking}) do
    Agent.save(booking)

    {:ok, id}
  end

  defp save_booking({:error, _reason} = error), do: error
end
