defmodule Flightex.Users.CreateOrUpdateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Flightex.Users.{Agent, CreateOrUpdate}
  alias Flightex.Users.User

  describe "call/1" do
    setup do
      Agent.start_link()

      :ok
    end

    test "when all params are valid, returns a tuple" do
      params = %{
        name: "Jp",
        email: "jp@banana.com",
        cpf: "12345678900"
      }

      CreateOrUpdate.call(params)

      {:ok, response} = Agent.get_by_cpf(params.cpf)

      expected_response = %User{
        cpf: "12345678900",
        email: "jp@banana.com",
        id: response.id,
        name: "Jp"
      }

      assert response == expected_response
    end

    test "when cpf is not a string, returns an error" do
      params = %{
        name: "Jp",
        email: "jp@banana.com",
        cpf: 12_345_678_900
      }

      expected_response = {:error, "Cpf must be a string!"}

      response = CreateOrUpdate.call(params)

      assert response == expected_response
    end
  end
end
