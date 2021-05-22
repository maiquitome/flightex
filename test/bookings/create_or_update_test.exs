defmodule Flightex.Bookings.CreateOrUpdateTest do
  @moduledoc false

  use ExUnit.Case, async: false

  alias Flightex.Bookings.{Agent, CreateOrUpdate}
  alias Flightex.Bookings.Booking

  describe "call/2" do
    setup do
      Flightex.start_agents()

      user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

      {:ok, user_uuid} = Flightex.create_user(user_params)

      {:ok, user_id: user_uuid}
    end

    test "when all params are valid, returns a booking", %{user_id: user_uuid} do
      booking_params = %{
        complete_date: "07/05/2001",
        local_origin: "Brasilia",
        local_destination: "Bananeiras"
      }

      {:ok, booking_uuid} = CreateOrUpdate.call(user_uuid, booking_params)

      {:ok, %{id: booking_id, complete_date: complete_date} = response} = Agent.get(booking_uuid)

      expected_response = %Booking{
        id: booking_id,
        complete_date: complete_date,
        local_destination: "Bananeiras",
        local_origin: "Brasilia",
        user_id: user_uuid
      }

      assert response == expected_response
    end

    test "when some param is not informed, returns an error", %{user_id: user_uuid} do
      response = CreateOrUpdate.call(user_uuid, %{})

      expected_response =
        {:error,
         "Inform all fields: user_uuid, %{complete_date: value, local_origin: value, local_destination: value}"}

      assert response == expected_response
    end
  end
end
