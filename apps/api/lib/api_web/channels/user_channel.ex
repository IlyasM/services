defmodule ApiWeb.UserChannel do
  use ApiWeb, :channel
  use ApiWeb, :db
  alias Phoenix.Socket.Broadcast, as: Sb
  alias ApiWeb.ChannelHelper, as: Helper

  def join(
        "user:" <> user_id = id,
        %{"last_event_id" => event_id, "chat_ids" => ids},
        socket
      ) do
    if authorized?(user_id, socket) do
      send(self(), :after_join)
    end

    {messages, statuses} = Helper.events(id, event_id)

    {:ok, %{messages: messages, statuses: statuses},
     socket
     |> assign(:tracking_ids, ids)
     |> assign(:online_map, %{})}
  end

  # message.type = reply|message|status
  def handle_in("new:msg", message, socket) do
    message = Helper.new_msg(message)
    # to_id is of this form: business:id
    ApiWeb.Endpoint.broadcast(message.to_id, "new:msg", message)
    {:reply, {:ok, message}, socket}
  end

  def handle_in("typing", %{"to_id" => id}, socket) do
    ApiWeb.Endpoint.broadcast(
      id,
      "typing",
      %{"id" => socket.assigns.current_user.id}
    )

    {:noreply, socket}
  end

  def handle_in("new:broadcast", %{"category" => category, "text" => text}, socket) do
    user_id = socket.assigns.current_user.id

    broadcast =
      Repo.insert!(%Broadcast{
        category_id: category.id,
        user_id: user_id,
        text: text
      })

    ApiWeb.Endpoint.broadcast("category:#{category.name}", "new:broadcast", %{
      category: category,
      broadcast: broadcast
    })

    {:reply, :ok, socket}
  end

  def handle_in("deactivate:broadcast", broadcast, socket) do
    broadcast =
      Repo.update!(Broadcast, %{broadcast | active: false})
      |> Repo.preload(:category)

    ApiWeb.Endpoint.broadcast(
      "category:#{broadcast.category.name}",
      "deactivate:broadcast",
      broadcast
    )

    {:reply, {:ok, broadcast}, socket}
  end

  intercept(["new:msg", "reply", "typing"])

  def handle_out("new:msg", message, socket) do
    online_map = Map.put(socket.assigns.online_map, message.from_id, true)

    push(socket, "new:msg", message)
    {:noreply, socket |> assign(:online_map, online_map)}
  end

  def handle_out("typing", payload, socket) do
    push(socket, "typing", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    online_map = Helper.online_map(socket.assigns.tracking_ids, "business")

    push(socket, "chats_online", online_map)

    {:noreply, socket |> assign(:online_map, online_map)}
  end

  defp authorized?(user_id, socket) do
    socket.assigns.current_user.id == String.to_integer(user_id)
  end
end
