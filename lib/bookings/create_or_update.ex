defmodule Flightex.Bookings.CreateOrUpdate do
  @moduledoc false

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UsersAgent

  @all_fields_message "Inform all fields: user_uuid, %{complete_date: value, local_origin: value, local_destination: value}"

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
  def call(user_uuid, %{} = booking_params) do
    with {:ok, _user} <- UsersAgent.get_by_id(user_uuid),
         {:ok, %Booking{}} = booking <- build_booking(user_uuid, booking_params) do
      save_booking(booking)
    else
      error -> error
    end
  end

  def call(_user_uuid, _any) do
    {:error, @all_fields_message}
  end

  defp build_booking(user_uuid, %{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination
       }) do
    Booking.build(complete_date, local_origin, local_destination, user_uuid)
  end

  defp build_booking(_user_uuid, _any) do
    {:error, @all_fields_message}
  end

  defp save_booking({:ok, %Booking{id: id} = booking}) do
    BookingsAgent.save(booking)

    {:ok, id}
  end

  defp save_booking({:error, _reason} = error), do: error
end
