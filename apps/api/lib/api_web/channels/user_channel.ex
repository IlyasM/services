defmodule ApiWeb.UserChannel do
  use ApiWeb, :channel
  alias Phoenix.Socket.Broadcast
  require Logger

  def join(
        "user:" <> user_id,
        %{"mode" => mode},
        socket
      ) do
    if authorized?(user_id, socket) do
      send(self(), :after_join)
    end

    # subscribes to event consumer group at kafka
    # if business to business event log
    # if user to user event log

    {:ok, socket}
  end

  intercept(["lol"])

  # def handle_in(event, payload, socket) do
  #   IO.inspect(event)
  #   {:reply, {:ok, payload}, socket}
  # end

  def handle_out("lol", payload, socket) do
    IO.inspect("here")
    Logger.info("yo")
    # broadcast(socket, "lol", payload)
    ApiWeb.Endpoint.broadcast("business:#{payload.id}", "shout", %{})
    push(socket, "lol", payload)
    {:noreply, socket}
  end

  def handle_info(
        %Broadcast{topic: "business:" <> _, event: ev, payload: payload},
        socket
      ) do
    IO.inspect("here we go ")
    IO.inspect(ev)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    current_user = socket.assigns.current_user
    # IO.inspect(current_user.name)
    {:noreply, socket}
  end

  # -=-=-=-=-=-=-=-=-=-PRIVATE API
  defp authorized?(user_id, socket) do
    true
  end
end
