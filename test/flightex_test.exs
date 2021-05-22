defmodule FlightexTest do
  @moduledoc false

  use ExUnit.Case

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Factory
  alias Flightex.Users.Agent, as: UsersAgent

  describe "create_user/1" do
    setup do
      {:ok, _pid} = Flightex.start_agents()

      :ok
    end

    test "when all params are valid, creates the user" do
      user_params = %{
        name: "Maiqui",
        email: "maiquitome@gmail.com",
        cpf: "011.123.012-26"
      }

      assert {:ok, _user_uuid} = Flightex.create_user(user_params)
    end
  end

  describe "create_booking/2" do
    setup do
      {:ok, _pid} = Flightex.start_agents()

      {:ok, user_uuid} =
        :user
        |> Factory.build()
        |> UsersAgent.save()

      {:ok, user_id: user_uuid}
    end

    test "when all params are valid, creates the flight booking", %{user_id: user_uuid} do
      booking_params = %{
        complete_date: "13/05/2022",
        local_origin: "Porto Algre",
        local_destination: "São Paulo"
      }

      assert {:ok, _booking_id} = Flightex.create_booking(user_uuid, booking_params)
    end
  end

  describe "get_booking/1" do
    setup do
      {:ok, _pid} = Flightex.start_agents()

      :ok
    end

    test "when the booking id exists, returns the booking" do
      {:ok, booking_uuid} =
        :booking
        |> Factory.build()
        |> BookingsAgent.save()

      response = Flightex.get_booking(booking_uuid)

      expected_response =
        {:ok,
         %Booking{
           complete_date: ~N[2001-05-07 03:05:00],
           id: booking_uuid,
           local_destination: "Bananeiras",
           local_origin: "Brasilia",
           user_id: "12345678900"
         }}

      assert response == expected_response
    end
  end

  describe "generate_report/3" do
    setup do
      {:ok, _pid} = Flightex.start_agents()

      :ok
    end

    test "when all params are valid, creates the report file" do
      %{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      } = booking1 = Factory.build(:booking)

      BookingsAgent.save(booking1)

      content1 = "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"

      %{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      } = booking2 = Factory.build(:booking, complete_date: ~N[2023-12-30 03:05:00])

      BookingsAgent.save(booking2)

      content2 = "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"

      {:ok, "Report generated succesfully"} =
        Flightex.generate_report("01/01/2001", "30/12/2023", "report_test2.csv")

      {:ok, response} = File.read("report_test2.csv")

      assert response =~ content1
      assert response =~ content2
    end
  end
end
