defmodule ApiWeb.CategoryController do
  use ApiWeb, :controller
  use ApiWeb, :db

  def index(conn, _params) do
    categories = Repo.all(Category)
    json(conn, %{categories: categories})
  end

  # on success send token to client
end
