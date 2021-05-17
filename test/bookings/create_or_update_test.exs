defmodule Flightex.Bookings.CreateOrUpdateTest do
  use ExUnit.Case, async: false

  alias Flightex.Bookings.{Agent, CreateOrUpdate}

  describe "call/1" do
    setup do
      Agent.start_link(%{})

      :ok
    end

    test "when all params are valid, returns a valid tuple" do
      params = %{
        complete_date: [2001, 5, 7, 3, 5, 0],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      {_ok, uuid} = CreateOrUpdate.call(params)

      {_ok, response} = Agent.get(uuid)

      expected_response = %Flightex.Bookings.Booking{
        id: response.id,
        complete_date: [2001, 5, 7, 3, 5, 0],
        local_destination: "Bananeiras",
        local_origin: "Brasilia",
        user_id: "12345678900"
      }

      assert response == expected_response
    end
  end
end
