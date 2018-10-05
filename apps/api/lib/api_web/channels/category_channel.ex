defmodule ApiWeb.CategoryChannel do
  use ApiWeb, :channel

  def join(_category_name, _, socket) do
    {:ok, %{}, socket}
  end

  intercept(["new", "deactivate"])

  def handle_out("new", payload, socket) do
    broadcast(socket, "new:broadcast", payload)
    {:noreply, socket}
  end

  def handle_out("deactivate", payload, socket) do
    broadcast(socket, "deactivate:broadcast", payload)
    {:noreply, socket}
  end
end
