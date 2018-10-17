defmodule ApiWeb.AuthTest do
  use ApiWeb.ConnCase
  use ApiWeb, :db

  @email "ilyas77777@gmail.com"

  test "POST /register-- successful code retrieval", %{conn: conn} do
    conn =
      post(conn, "/api/register", %{
        email: @email
      })

    return_string = "We have sent verification code to #{@email}"

    assert %{"response" => return_string} = json_response(conn, 200)
  end

  test "POST /verify", %{conn: conn} do
    code = Api.Accounts.register(@email)

    conn =
      post(conn, "/api/verify", %{
        email: @email,
        code: code
      })

    assert %{"token" => _} = json_response(conn, 200)
  end

  test "incorrect code", %{conn: conn} do
    Api.Accounts.register(@email)

    conn =
      post(conn, "/api/verify", %{
        email: @email,
        code: 21313
      })

    assert %{"error" => _} = json_response(conn, 200)
  end
end
