defmodule ApiWeb.BusinessChannel do
  use ApiWeb, :channel
  use ApiWeb, :db
  alias Phoenix.Socket.Broadcast, as: Sb
  alias ApiWeb.ChannelHelper, as: Helper

  def join(
        "business:" <> business_id = id,
        %{"last_event_id" => event_id, "chat_ids" => ids},
        socket
      ) do
    send(self(), {:after_join, ids})

    business = Api.CacheWorker.lookup(Api.CacheWorker, id)

    :ok = ApiWeb.Endpoint.subscribe("category:#{business.category.name}")

    {messages, statuses, last_event_id} = Helper.events(id, event_id)

    {:ok, %{messages: messages, statuses: statuses, last_event_id: last_event_id},
     socket
     |> assign(:entity_id, id)
     |> assign(:tracking_ids, ids)
     |> assign(:business, business)
     |> assign(:online_map, %{})}
  end

  def handle_in("new:msg", message, socket) do
    message = Helper.new_msg(message)

    # to_id is of this form: user:id
    ApiWeb.Endpoint.broadcast(message.to_id, "new:msg", message)
    {:reply, {:ok, message}, socket}
  end

  def handle_in("bulk:delivered", params, socket) do
    messages =
      params["ids"]
      |> Enum.map(fn id ->
        %{
          text: "delivered",
          type: "status",
          to_id: id,
          from_id: socket.assigns.entity_id,
          inserted_at: DateTime.utc_now(),
          updated_at: DateTime.utc_now()
        }
      end)

    Helper.msg_bulk(messages)
    |> Enum.each(&ApiWeb.Endpoint.broadcast(&1.to_id, "new:msg", &1))

    {:noreply, socket}
  end

  def handle_in("typing", %{"to_id" => id}, socket) do
    ApiWeb.Endpoint.broadcast(
      id,
      "typing",
      %{"id" => socket.assigns.current_user.id}
    )

    {:noreply, socket}
  end

  intercept(["new:msg", "typing"])

  def handle_out("new:msg", message, socket) do
    online_map = Map.put(socket.assigns.online_map, message.from_id, true)
    push(socket, "new:msg", message)
    {:noreply, socket |> assign(:online_map, online_map)}
  end

  def handle_out("typing", payload, socket) do
    push(socket, "typing", payload)
    {:noreply, socket}
  end

  #  broadcast reaches the business
  def handle_info(
        %Sb{event: "new:broadcast", payload: payload},
        socket
      ) do
    push(socket, "new:broadcast", payload)
    {:noreply, socket}
  end

  def handle_info(
        %Sb{topic: "category:" <> _, event: "deactivate:broadcast", payload: payload},
        socket
      ) do
    push(socket, "deactivate:broadcast", payload)
    {:noreply, socket}
  end

  def handle_info({:after_join, ids}, socket) do
    online_map = Helper.online_map(ids, "user")

    push(socket, "chats_online", online_map)

    {:noreply, socket |> assign(:online_map, online_map)}
  end
end
