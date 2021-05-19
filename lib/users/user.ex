defmodule Flightex.Users.User do
  @moduledoc false

  @message_all_fields "All fields must be informed: name, email, cpf"

  @keys [:name, :email, :cpf, :id]

  @enforce_keys @keys

  defstruct @keys

  @doc """
  Creates a user.

  ## Examples

  - user succesfully created:

        iex> Flightex.Users.User.build("Maiqui", "maiquitome@gmail.com", "011.123.012-26")
        {:ok,
          %Flightex.Users.User{
            cpf: "011.123.012-26",
            email: "maiquitome@gmail.com",
            id: "4c54de7d-8314-46d9-aab2-8b816d8f07ec",
            name: "Maiqui"
          }
        }

  - error, name must be a string:

        iex> Flightex.Users.User.build(:maiqui, "maiquitome@gmail.com", "011.123.012-26")
        {:error, "Name must be a string!"}

  - error, all fields must be informed:

        iex> Flightex.Users.User.build(:maiqui, "maiquitome@gmail.com")
        {:error, "All fields must be informed: name, email, cpf"}

        iex> Flightex.Users.User.build(:maiqui)
        {:error, "All fields must be informed: name, email, cpf"}

        iex> Flightex.Users.User.build()
        {:error, "All fields must be informed: name, email, cpf"}

        iex> Flightex.Users.User.build
        {:error, "All fields must be informed: name, email, cpf"}

  """
  def build(name, _email, _cpf) when not is_bitstring(name) do
    {:error, "Name must be a string!"}
  end

  def build(name, email, cpf) do
    id = UUID.uuid4()

    {:ok,
     %__MODULE__{
       id: id,
       name: name,
       email: email,
       cpf: cpf
     }}
  end

  def build(_, _), do: {:error, @message_all_fields}

  def build(_), do: {:error, @message_all_fields}

  def build, do: {:error, @message_all_fields}
end
