defmodule ApiWeb.AuthController do
  use ApiWeb, :controller
  use ApiWeb, :db
  alias Api.Accounts

  def get_code(conn, %{"email" => email}) do
    code = Accounts.register(email)
    Api.MailWorker.send_code(email, code)
    json(conn, %{response: "We have sent verification code to #{email}"})
  end

  # on success send token to client
  def verify_code(conn, %{"code" => code, "email" => email}) do
    res =
      case Accounts.verify_code(code, email) do
        %Token{value: value} -> %{token: value}
        {:error, error_msg} -> %{error: error_msg}
      end

    json(conn, res)
  end
end
