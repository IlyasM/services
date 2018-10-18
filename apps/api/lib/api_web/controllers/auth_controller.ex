defmodule ApiWeb.AuthController do
  use ApiWeb, :controller
  use ApiWeb, :db
  alias Api.Accounts

  def get_code(conn, %{"email" => email}) do
    code = Accounts.register(email)
    Task.start_link(fn -> Api.MailWorker.send_code(email, code) end)

    json(conn, %{response: "We have sent verification code to #{email}"})
  end

  # on success send token to client
  def verify_code(conn, %{"code" => code, "email" => email}) do
    res =
      case Accounts.verify_code(code, email) do
        %Token{value: value} ->
          json(conn, %{token: value})

        {:error, error_msg} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(ApiWeb.ErrorView, "error.json", error: error_msg)
      end
  end
end
