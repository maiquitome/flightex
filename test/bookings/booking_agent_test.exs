defmodule Flightex.Bookings.AgentTest do
  @moduledoc false

  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UsersAgent

  describe "save/1" do
    setup do
      BookingsAgent.start_link()
      UsersAgent.start_link()

      user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

      {:ok, user_uuid} = Flightex.create_user(user_params)

      {:ok, user_id: user_uuid}
    end

    test "when all params are valid, returns a booking uuid", %{user_id: user_uuid} do
      response =
        :booking
        |> build(user_id: user_uuid)
        |> BookingsAgent.save()

      assert {:ok, _booking_id} = response
    end
  end

  describe "get/1" do
    setup do
      BookingsAgent.start_link()
      UsersAgent.start_link()

      user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

      {:ok, user_uuid} = Flightex.create_user(user_params)

      {:ok, user_id: user_uuid}
    end

    test "when the booking id exists, returns the booking", %{user_id: user_uuid} do
      {:ok, booking_id} =
        :booking
        |> build(user_id: user_uuid)
        |> BookingsAgent.save()

      response = BookingsAgent.get(booking_id)

      expected_response =
        {:ok,
         %Booking{
           complete_date: ~N[2001-05-07 03:05:00],
           id: booking_id,
           local_destination: "Bananeiras",
           local_origin: "Brasilia",
           user_id: user_uuid
         }}

      assert response == expected_response
    end

    test "when the booking wasn't found, returns an error" do
      response = BookingsAgent.get("banana")

      expected_response = {:error, "Flight Booking not found!"}

      assert response == expected_response
    end
  end

  describe "get_all/0" do
    setup do
      BookingsAgent.start_link()
      UsersAgent.start_link()

      user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

      {:ok, user_uuid} = Flightex.create_user(user_params)

      {:ok, user_id: user_uuid}
    end

    test "returns all registered bookings", %{user_id: user_uuid} do
      {:ok, booking_id1} =
        :booking
        |> build(user_id: user_uuid)
        |> BookingsAgent.save()

      {:ok, booking_id2} =
        :booking
        |> build(user_id: user_uuid, local_origin: "Porto Alegre")
        |> BookingsAgent.save()

      response = BookingsAgent.get_all()

      expected_response = %{
        booking_id1 => %Booking{
          complete_date: ~N[2001-05-07 03:05:00],
          id: booking_id1,
          local_destination: "Bananeiras",
          local_origin: "Brasilia",
          user_id: user_uuid
        },
        booking_id2 => %Booking{
          complete_date: ~N[2001-05-07 03:05:00],
          id: booking_id2,
          local_destination: "Bananeiras",
          local_origin: "Porto Alegre",
          user_id: user_uuid
        }
      }

      assert response == expected_response
    end
  end
end
