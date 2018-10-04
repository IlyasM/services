defmodule ApiWeb.CategoryChannel do
  use ApiWeb, :channel

  def join("category:" <> category_id, _, socket) do
    {:ok, %{}, socket}
  end
end
