# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "build/3" do
    setup do
      Flightex.start_agents()

      user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

      {:ok, user_uuid} = Flightex.create_user(user_params)

      {:ok, user_id: user_uuid}
    end

    test "when called, returns the content", %{user_id: user_uuid} do
      params1 = %{
        complete_date: "07/05/2001",
        local_origin: "Brasilia",
        local_destination: "Bananeiras"
      }

      {:ok, booking_id1} = Flightex.create_booking(user_uuid, params1)

      {:ok, %{complete_date: naive_date_time1}} = Flightex.get_booking(booking_id1)

      content1 = "#{user_uuid},Brasilia,Bananeiras,#{naive_date_time1}\n"

      params2 = %{
        complete_date: "30/05/2001",
        local_origin: "Brasilia",
        local_destination: "Bananeiras"
      }

      {:ok, booking_id2} = Flightex.create_booking(user_uuid, params2)

      {:ok, %{complete_date: naive_date_time2}} = Flightex.get_booking(booking_id2)

      content2 = "#{user_uuid},Brasilia,Bananeiras,#{naive_date_time2}\n"

      Report.build("06/05/2001", "30/05/2001", "report_test.csv")

      {:ok, file} = File.read("report_test.csv")

      assert file =~ content1
      assert file =~ content2
    end
  end
end
