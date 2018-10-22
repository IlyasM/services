defmodule ApiWeb.BusinessController do
  use ApiWeb, :controller
  use ApiWeb, :db

  def create(conn, %{"business" => params}) do
    current_user = conn.assigns.current_user

    changeset =
      Business.changeset(
        %Business{},
        Map.put(params, "user_id", current_user.id)
      )

    business =
      Repo.insert!(changeset)
      |> Repo.preload(:category)

    Api.CacheWorker.new(business)

    json(conn, %{business: business})
  end

  # on success send token to client
end
