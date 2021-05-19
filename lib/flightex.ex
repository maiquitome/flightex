defmodule Flightex do
  @moduledoc """
  Flight booking/reservation application.
  Registration of users and registration of flight bookings for a user.
  """

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Users.Agent, as: UsersAgent
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser

  def start_agents do
    UsersAgent.start_link()
    BookingsAgent.start_link()
  end

  @doc """
  Creates an user and saves in the agent.

  ## Examples

    - the user agent must have been initialized

          iex> {:ok, _pid} = Flightex.start_agents

    - user succesfully created:

          iex> user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

          iex> {:ok, user_uuid} = Flightex.create_user(user_params)

    - error in name:

          iex> user_params = %{user_params | name: 1}
          %{cpf: "011.123.012-26", email: "maiquitome@gmail.com", name: 1}

          iex> Flightex.create_user(user_params)
          {:error, "Name must be a string!"}

  """
  defdelegate create_user(params),
    to: CreateOrUpdateUser,
    as: :call

  @doc """
  Creates a booking to a user and saves it in the agent.

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

        iex> {:ok, booking_id} = Flightex.create_booking(user_uuid, booking_params)

  """
  defdelegate create_booking(user_uuid, params),
    to: CreateOrUpdateBooking,
    as: :call
end
