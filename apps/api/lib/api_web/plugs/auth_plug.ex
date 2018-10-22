defmodule ApiWeb.AuthPlug do
  import Plug.Conn
  use ApiWeb, :db
  alias Api.Accounts
  def init(opts), do: opts

  def call(conn, _opts) do
    case extract_token(conn) do
      {:ok, user} ->
        authorized(conn, user)

      {:error, reason} ->
        unauthorized(conn, reason)
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [header] -> get_token_from(header)
      _ -> {:error, "missing auth header"}
    end
  end

  defp get_token_from(header) do
    try do
      "Bearer: " <> value = header

      case Accounts.check_token(value) do
        {:ok, user} -> {:ok, user}
        false -> {:error, "token expired"}
      end
    catch
      _ -> {:error, "incorrect auth header params"}
    end
  end

  defp authorized(conn, user) do
    assign(conn, :current_user, user)
  end

  defp unauthorized(conn, reason) do
    conn |> send_resp(401, reason) |> halt()
  end
end
