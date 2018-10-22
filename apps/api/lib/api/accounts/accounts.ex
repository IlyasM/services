defmodule Api.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  use ApiWeb, :db
  # half a year
  @verified_time 24_000_000
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  # returns code | throws EctoConstraintError if email is not unique
  def register(email) do
    {:ok, code} =
      Repo.transaction(fn ->
        user = get_or_insert(email)

        token =
          case Repo.get_by(Token, user_id: user.id) do
            %Token{} = token ->
              if Token.verify?(token.value, 300) do
                token
              else
                delete_expired(token)
                insert_token_for(user)
              end

            _ ->
              insert_token_for(user)
          end

        token.code
      end)

    code
  end

  # returns token | error string
  def verify_code(code, email) do
    Token.verify_code(code, email)
  end

  # returns true|false
  def check_token(value) do
    Token.verify?(value, @verified_time)
  end

  defp get_or_insert(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        User.changeset(%User{}, %{email: email})
        |> Repo.insert!()

      user ->
        user
    end
  end

  defp delete_expired(token) do
    Repo.delete(token)
  end

  defp insert_token_for(user) do
    Repo.insert!(Token.changeset(%Token{}, user))
  end
end
