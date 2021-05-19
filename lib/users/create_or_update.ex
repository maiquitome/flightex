defmodule Flightex.Users.CreateOrUpdate do
  @moduledoc """
  Creates and saves, or updates in the Agent.
  """
  alias Flightex.Users.{Agent, User}

  @doc """
  Creates and saves, or updates in the Agent.

  ## Examples

    - user succesfully created:

          iex> user_params = %{name: "Maiqui", email: "maiquitome@gmail.com", cpf: "011.123.012-26"}

          iex> {:ok, uuid} = Flightex.Users.CreateOrUpdate.call(user_params)

    - error in name:

          iex> user_params = %{user_params | name: 1}
          %{cpf: "011.123.012-26", email: "maiquitome@gmail.com", name: 1}

          iex> Flightex.Users.CreateOrUpdate.call(user_params)
          {:error, "Name must be a string!"}

  """
  def call(%{name: name, email: email, cpf: cpf}) do
    name
    |> User.build(email, cpf)
    |> save_user()
  end

  defp save_user({:ok, %User{id: uuid} = user}) do
    Agent.save(user)

    {:ok, uuid}
  end

  defp save_user({:error, _reason} = error), do: error
end
