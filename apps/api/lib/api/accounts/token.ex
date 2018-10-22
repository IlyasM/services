defmodule Api.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset
  use ApiWeb, :db
  import Ecto.Query

  schema "tokens" do
    field(:value, :string)
    field(:code, :integer)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(struct, %User{} = user) do
    map = %{code: random_code(), value: generate_token(user)}

    struct
    |> cast(map, [:code, :value])
    |> put_assoc(:user, user)
  end

  @code_time 300
  def verify_code(code, email) do
    with {:ok, %{token: token}} <- multi(code, email),
         {:ok, _} <- verify?(token.value, @code_time) do
      token
    else
      {:error, :user, _, _} ->
        {:error, "user not found"}

      {:error, :token, _error, _} ->
        {:error, "incorrect code"}

      false ->
        {:error, "code expired"}
    end
  end

  def verify?(value, time) do
    case Phoenix.Token.verify(
           context(),
           "user salt",
           value,
           max_age: time
         ) do
      {:ok, res} ->
        {:ok, get_user(res)}

      _ ->
        false
    end
  end

  # -=-=-=-=- private methods
  defp multi(code, email) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:user, fn _ ->
      case Repo.get_by(User, email: email) do
        nil -> {:error, "user not found"}
        user -> {:ok, user}
      end
    end)
    |> Ecto.Multi.run(:token, fn %{user: user} ->
      case Repo.get_by(__MODULE__, user_id: user.id, code: code) do
        nil -> {:error, "incorrect code"}
        token -> {:ok, token}
      end
    end)
    |> Repo.transaction()
  end

  defp get_user(str) do
    [email, id] = String.split(str, ":")
    %{email: email, id: String.to_integer(id)}
  end

  defp random_code do
    :random.seed(:os.timestamp())
    round(:random.uniform() * 9000) + 1000
  end

  defp generate_token(nil), do: nil

  defp generate_token(user) do
    Phoenix.Token.sign(
      context(),
      "user salt",
      user.email <> ":" <> Integer.to_string(user.id)
    )
  end

  defp context do
    System.get_env("APP_SECRET")
  end
end
