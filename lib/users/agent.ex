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
  Returns all registered users.

  ## Examples

    - the user agent has to have been initialized

          iex> {:ok, _pid} =  Flightex.start_agents

    - creating a user

          iex> user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

          iex> {:ok, user_uuid} = Flightex.create_user(user_params)
          {:ok, "b77f161c-13e7-4b61-9bcf-db87587bb179"}

    - searching all users

          iex> Flightex.Users.Agent.get_all
          %{
            "011.123.012-26" => %Flightex.Users.User{
              cpf: "011.123.012-26",
              email: "maiquitome@gmail.com",
              id: "36c3a6f9-67b6-4026-a1ef-a18476943e81",
              name: "Maiqui"
            }
          }

  """
  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Get a user searching by id.

  ## Examples

    - the user agent has to have been initialized

          iex> {:ok, _pid} =  Flightex.start_agents

    - creating a user

          iex> user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

          iex> {:ok, user_uuid} = Flightex.create_user(user_params)
          {:ok, "b77f161c-13e7-4b61-9bcf-db87587bb179"}

    - searching the user by id

          iex> {:ok, user_found} = Flightex.Users.Agent.get_by_id(user_uuid)
          {:ok,
          %Flightex.Users.User{
            cpf: "011.123.012-26",
            email: "maiquitome@gmail.com",
            id: "b77f161c-13e7-4b61-9bcf-db87587bb179",
            name: "Maiqui"
          }}

    - error: user not found

          iex> Flightex.Users.Agent.get_by_id("801737b0-6c1f-43b7-af51-97de2e574")
          {:error, "User not found!"}

  """
  def get_by_id(id) do
    Agent.get(__MODULE__, fn all_users -> get_user_by_id(all_users, id) end)
  end

  @doc """
  Get a user searching by cpf.

  ## Examples

    - the user agent has to have been initialized

          iex> {:ok, _pid} =  Flightex.start_agents

    - creating a user

          iex> user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

          iex> {:ok, user_uuid} = Flightex.create_user(user_params)
          {:ok, "b77f161c-13e7-4b61-9bcf-db87587bb179"}

    - searching the user by cpf

          iex> {:ok, user_found} = Flightex.Users.Agent.get_by_cpf("011.123.012-26")
          {:ok,
          %Flightex.Users.User{
            cpf: "011.123.012-26",
            email: "maiquitome@gmail.com",
            id: "801737b0-6c1f-43b7-af51-97de2e574b96",
            name: "Maiqui"
          }}

  """
  def get_by_cpf(cpf) do
    Agent.get(__MODULE__, fn state -> get_user_by_cpf(state, cpf) end)
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

  defp get_user_by_id(state, id) do
    state
    |> Map.values()
    |> Enum.find(fn curr_user_map -> curr_user_map.id == id end)
    |> handle_get_user()
  end

  defp get_user_by_cpf(state, cpf) do
    state
    |> Map.get(cpf)
    |> handle_get_user()
  end

  defp handle_get_user(%User{} = user), do: {:ok, user}
  defp handle_get_user(nil), do: {:error, "User not found!"}
end
