defmodule ApiWeb.AuthTest do
  use ApiWeb.ConnCase
  use ApiWeb, :db
  alias Api.Accounts
  @email "ilyas77777@gmail.com"
  def fixture(:token) do
    code = Accounts.register(@email)
    token = Token.verify_code(code, @email)
    token
  end

  def fixture(:category) do
    Repo.insert!(%Category{name: "flats"})
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "auth plug" do
    setup [:create_token]

    test "correctly extracts token from headers", %{
      conn: conn,
      category: category
    } do
      conn = get(conn, "/api/categories")

      assert json_response(conn, 200)["categories"] == [
               %{"name" => "flats", "id" => category.id, "question" => nil}
             ]
    end
  end

  defp create_token(_) do
    token = fixture(:token)
    category = fixture(:category)

    {:ok,
     conn:
       put_req_header(build_conn(), "authorization", "Bearer: #{token.value}"),
     category: category}
  end
end
