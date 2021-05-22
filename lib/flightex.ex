defmodule Flightex do
  @moduledoc """
  Flight booking/reservation application.
  Registration of users and registration of flight bookings for a user.
  """

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
  alias Flightex.Bookings.Report, as: BookingsReport
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

          iex> {:ok, _pid} = Flightex.start_agents

  - creating the user:

        iex> user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

        iex> {:ok, user_uuid} = Flightex.create_user(user_params)

  - creating the book

        iex> booking_params = %{complete_date: "13/05/2022", local_origin: "Porto Algre", local_destination: "São Paulo"}
        %{
          complete_date: "13/05/2022",
          local_destination: "São Paulo",
          local_origin: "Porto Algre"
        }

        iex> {:ok, booking_id} = Flightex.create_booking(user_uuid, booking_params)

  - error in user id

        iex> Flightex.create_booking("e6b4a5f7-ce13-4fc0-9ea8-", booking_params)
        {:error, "User not found!"}

  """
  defdelegate create_booking(user_uuid, params),
    to: CreateOrUpdateBooking,
    as: :call

  @doc """

  ## Examples

    - the user agent and flight booking agent has to have been started

          iex> {:ok, _pid} = Flightex.start_agents

    - creating user

          iex> user_params = %{cpf: "111.111.111", email: "mike@gmail.com", name: "Mike"}

          iex> Flightex.create_user(user_params)
          {:ok, "e6b4a5f7-ce13-4fc0-9ea8-34432ee50732"}

    - creating a flight booking

          iex> booking_params
          %{
            complete_date: "13/05/2022",
            local_destination: "São Paulo",
            local_origin: "Porto Algre"
          }

          iex> Flightex.create_booking("e6b4a5f7-ce13-4fc0-9ea8-34432ee50732", booking_params)
          {:ok, "dd66846b-3446-41b1-b957-358a9cc7b9df"}

    - succesfully getting the flight booking

          iex> Flightex.get_booking("dd66846b-3446-41b1-b957-358a9cc7b9df")
          {:ok,
          %Flightex.Bookings.Booking{
            complete_date: ~N[2022-05-13 00:00:00],
            id: "dd66846b-3446-41b1-b957-358a9cc7b9df",
            local_destination: "São Paulo",
            local_origin: "Porto Algre",
            user_id: "e6b4a5f7-ce13-4fc0-9ea8-34432ee50732"
          }}

    - error: the flight booking does not exist

          iex> Flightex.get_booking("dd66846b-3446-41b1-")
          {:error, "Flight Booking not found!"}
  """
  defdelegate get_booking(booking_id),
    to: BookingsAgent,
    as: :get

  defdelegate generate_report(from_date, to_date, file_name \\ "report.csv"),
    to: BookingsReport,
    as: :build
end
