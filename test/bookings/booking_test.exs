defmodule Flightex.Bookings.BookingTest do
  use ExUnit.Case, async: false

  alias Flightex.Bookings.Booking

  describe "build/4" do
    test "when all params are valid, returns a booking" do
      {_ok, response} =
        Booking.build(
          ~N[2001-05-07 01:46:20],
          "Brasilia",
          "ilha das bananas",
          "12345678900"
        )

      expected_response = %Flightex.Bookings.Booking{
        complete_date: ~N[2001-05-07 01:46:20],
        id: response.id,
        local_destination: "ilha das bananas",
        local_origin: "Brasilia",
        user_id: "12345678900"
      }

      assert response == expected_response
    end
  end
end
