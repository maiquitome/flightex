defmodule Flightex.Users.Agent do
  @moduledoc """
  Manages the user state.
  """

  use Agent

  alias Flightex.Users.User

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Returns the user.

  ## Examples

      iex> user = Flightex.Users.User.build("Maiqui", "maiquitome@gmail.com", "011.123.012-26")
      %Flightex.Users.User{
        cpf: "011.123.012-26",
        email: "maiquitome@gmail.com",
        id: "3b108193-38fa-48c4-b208-795c8c70b2f5",
        name: "Maiqui"
      }

      iex> Flightex.Users.Agent.start_link
      {:ok, #PID<0.2215.0>}

      iex> Flightex.Users.Agent.save(user)
      {:ok, "3b108193-38fa-48c4-b208-795c8c70b2f5"}

      iex> {:ok, user} = Flightex.Users.Agent.get("011.123..012-26")
      {:ok,
      %Flightex.Users.User{
        cpf: "011.123..012-26",
        email: "maiquitome@gmail.com",
        id: "3b108193-38fa-48c4-b208-795c8c70b2f5",
        name: "Maiqui"
      }}

  """
  def get(cpf) do
    Agent.get(__MODULE__, fn state -> get_user(state, cpf) end)
  end

  @doc """
  Saves a new user or updates an existing user.

  ## Examples

      iex> user = Flightex.Users.User.build("Maiqui", "maiquitome@gmail.com", "011.123.012-26")
      %Flightex.Users.User{
        cpf: "011.123.012-26",
        email: "maiquitome@gmail.com",
        id: "3b108193-38fa-48c4-b208-795c8c70b2f5",
        name: "Maiqui"
      }

      iex> {:ok, _pid} = Flightex.Users.Agent.start_link

      iex> Flightex.Users.Agent.save(user)
      {:ok, "3b108193-38fa-48c4-b208-795c8c70b2f5"}

      iex> {:ok, user} = Flightex.Users.Agent.get("011.123..012-26")
      {:ok,
      %Flightex.Users.User{
        cpf: "011.123..012-26",
        email: "maiquitome@gmail.com",
        id: "3b108193-38fa-48c4-b208-795c8c70b2f5",
        name: "Maiqui"
      }}

      iex> user = %{user | email: "maiquipirolli@outlook.com"}
      %Flightex.Users.User{
        cpf: "011.123.012-26",
        email: "maiquipirolli@outlook.com",
        id: "3b108193-38fa-48c4-b208-795c8c70b2f5",
        name: "Maiqui"
      }

      iex> Flightex.Users.Agent.save(user)
      {:ok, "3b108193-38fa-48c4-b208-795c8c70b2f5"}

      iex> {:ok, user} = Flightex.Users.Agent.get("011.123.012-26")
      {:ok,
      %Flightex.Users.User{
        cpf: "011.123.012-26",
        email: "maiquipirolli@outlook.com",
        id: "3b108193-38fa-48c4-b208-795c8c70b2f5",
        name: "Maiqui"
      }}

  """
  def save(%User{} = user) do
    Agent.update(__MODULE__, fn state -> update_user(state, user) end)

    {:ok, user.id}
  end

  defp update_user(state, %User{cpf: cpf} = user) do
    Map.put(state, cpf, user)
  end

  defp get_user(state, cpf) do
    case Map.get(state, cpf) do
      nil -> {:error, "User not found!"}
      user -> {:ok, user}
    end
  end
end
