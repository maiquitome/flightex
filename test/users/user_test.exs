defmodule Flightex.Users.UserTest do
  @moduledoc false

  use ExUnit.Case

  alias Flightex.Users.User

  import Flightex.Factory

  describe "build/3" do
    test "when all params are valid, returns the user" do
      {:ok, response} =
        User.build(
          "Jp",
          "jp@banana.com",
          "12345678900"
        )

      expected_response = build(:user, id: response.id)

      assert response == expected_response
    end

    test "when the name is not a string returns an error" do
      response =
        User.build(
          123_123,
          "jp@banana.com",
          "12345678900"
        )

      expected_response = {:error, "Name must be a string!"}

      assert response == expected_response
    end

    test "when the email is not a string returns an error" do
      response =
        User.build(
          "Jp",
          123,
          "12345678900"
        )

      expected_response = {:error, "Email must be a string!"}

      assert response == expected_response
    end

    test "when the cpf is not a string returns an error" do
      response =
        User.build(
          "Jp",
          "jp@banana.com",
          112_250_055
        )

      expected_response = {:error, "Cpf must be a string!"}

      assert response == expected_response
    end
  end
end
