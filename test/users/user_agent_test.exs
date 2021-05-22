defmodule Flightex.Users.AgentTest do
  @moduledoc false

  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  describe "save/1" do
    setup do
      UserAgent.start_link()

      id = UUID.uuid4()
      cpf = "12345678900"

      {:ok, id: id, cpf: cpf}
    end

    test "when the user is saved, returns a tuple", %{id: id, cpf: cpf} do
      {:ok, _uuid} =
        :user
        |> build(id: id, cpf: cpf)
        |> UserAgent.save()

      response = UserAgent.get_by_cpf(cpf)

      expected_response = {:ok, %User{cpf: cpf, email: "jp@banana.com", id: id, name: "Jp"}}

      assert response == expected_response
    end
  end

  describe "get_all/0" do
    test "when the user is saved, returns a tuple" do
      UserAgent.start_link()

      {:ok, user_id1} =
        :user
        |> build(id: UUID.uuid4(), cpf: "12345678900")
        |> UserAgent.save()

      {:ok, user_id2} =
        :user
        |> build(name: "Maiqui", email: "maiqui@gmail.com", id: UUID.uuid4(), cpf: "12345678901")
        |> UserAgent.save()

      response = UserAgent.get_all()

      expected_response = %{
        "12345678900" => %User{
          cpf: "12345678900",
          email: "jp@banana.com",
          id: user_id1,
          name: "Jp"
        },
        "12345678901" => %User{
          cpf: "12345678901",
          email: "maiqui@gmail.com",
          id: user_id2,
          name: "Maiqui"
        }
      }

      assert response == expected_response
    end
  end

  describe "get_by_cpf/1" do
    setup do
      UserAgent.start_link(%{})

      id = UUID.uuid4()
      cpf = "12345678900"

      {:ok, id: id, cpf: cpf}
    end

    test "when the user is found, returns the user", %{id: id, cpf: cpf} do
      {:ok, _uuid} =
        :user
        |> build(id: id, cpf: cpf)
        |> UserAgent.save()

      response = UserAgent.get_by_cpf(cpf)

      expected_response = {:ok, %User{cpf: cpf, email: "jp@banana.com", id: id, name: "Jp"}}

      assert response == expected_response
    end

    test "when the user is not found, returns an error", %{id: id, cpf: cpf} do
      {:ok, _uuid} =
        :user
        |> build(id: id, cpf: cpf)
        |> UserAgent.save()

      response = UserAgent.get_by_cpf("banana")

      expected_response = {:error, "User not found!"}

      assert response == expected_response
    end
  end
end
