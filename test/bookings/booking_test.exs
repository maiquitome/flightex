defmodule Flightex.Bookings.BookingTest do
  @moduledoc false

  use ExUnit.Case, async: false

  alias Flightex.Bookings.Booking

  describe "build/4" do
    setup do
      Flightex.start_agents()

      user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

      {:ok, user_uuid} = Flightex.create_user(user_params)

      {:ok, user_uuid: user_uuid}
    end

    test "when all params are valid, returns a booking", %{user_uuid: user_uuid} do
      {:ok, %Booking{id: booking_id, complete_date: naive_date_time}} =
        response =
        Booking.build(
          "07/05/2001",
          "Brasilia",
          "ilha das bananas",
          user_uuid
        )

      expected_response =
        {:ok,
         %Booking{
           complete_date: naive_date_time,
           id: booking_id,
           local_destination: "ilha das bananas",
           local_origin: "Brasilia",
           user_id: user_uuid
         }}

      assert response == expected_response
    end
  end
end
