defmodule Flightex.Bookings.Booking do
  @moduledoc false

  @message_all_fields "All fields must be informed: complete_date, local_origin, local_destination, user_id"

  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]

  @enforce_keys @keys

  defstruct @keys

  @doc """

  ## Examples

    - creating a user:

          iex> {:ok, %{id: user_id} = user} = Flightex.Users.User.build("Maiqui", "maiquitome@gmail.com", "011.123.012-26")
          {:ok,
          %Flightex.Users.User{
            cpf: "011.123.012-26",
            email: "maiquitome@gmail.com",
            id: "f09412f1-af39-4899-8a4e-5bb97a1f653a",
            name: "Maiqui"
          }}

    - creating the booking:

          iex> Flightex.Bookings.Booking.build("13/05/2022", "Porto Algre", "São Paulo", user_id)
          {:ok,
          %Flightex.Bookings.Booking{
            complete_date: ~N[2022-05-13 00:00:00],
            id: "a29b0a35-ef08-49c1-88ba-5d85736306fa",
            local_destination: "São Paulo",
            local_origin: "Porto Algre",
            user_id: "f09412f1-af39-4899-8a4e-5bb97a1f653a"
          }}

    - error, all fields must be informed:

          iex> Flightex.Bookings.Booking.build("13/05/2022", "Porto Algre", "São Paulo")
          {:error,
          "All fields must be informed: complete_date, local_origin, local_destination, user_id"}

          iex> Flightex.Bookings.Booking.build("13/05/2022", "Porto Algre")
          {:error,
          "All fields must be informed: complete_date, local_origin, local_destination, user_id"}

          iex> Flightex.Bookings.Booking.build("13/05/2022")
          {:error,
          "All fields must be informed: complete_date, local_origin, local_destination, user_id"}

          iex> Flightex.Bookings.Booking.build()
          {:error,
          "All fields must be informed: complete_date, local_origin, local_destination, user_id"}

          iex> Flightex.Bookings.Booking.build
          {:error,
          "All fields must be informed: complete_date, local_origin, local_destination, user_id"}

  """
  def build(complete_date, local_origin, local_destination, user_id) do
    id = UUID.uuid4()

    complete_date = parse_br_date_to_naive(complete_date)

    {:ok,
     %__MODULE__{
       complete_date: complete_date,
       local_origin: local_origin,
       local_destination: local_destination,
       user_id: user_id,
       id: id
     }}
  end

  def build(_, _, _), do: {:error, @message_all_fields}

  def build(_, _), do: {:error, @message_all_fields}

  def build(_), do: {:error, @message_all_fields}

  def build, do: {:error, @message_all_fields}

  defp parse_br_date_to_naive(complete_date_br) do
    [day, month, year] = String.split(complete_date_br, "/", trim: true)

    day = String.to_integer(day)
    month = String.to_integer(month)
    year = String.to_integer(year)

    NaiveDateTime.new!(year, month, day, 0, 0, 0)
  end
end
