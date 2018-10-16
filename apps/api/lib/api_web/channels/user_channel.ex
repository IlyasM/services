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

    {messages, statuses, last_event_id} = Helper.events(id, event_id)

    {:ok, %{messages: messages, statuses: statuses, last_event_id: last_event_id},
     socket
     |> assign(:entity_id, id)
     |> assign(:tracking_ids, ids)
     |> assign(:online_map, %{})}
  end

  # message.type = reply|message|status
  def handle_in("new:msg", message, socket) do
    message = Helper.new_msg(message)
    # to_id is of this form: business:id
    ApiWeb.Endpoint.broadcast(message.to_id, "new:msg", message)

    if message.type == "status" do
      {:noreply, socket}
    else
      {:reply, {:ok, message}, socket}
    end
  end

  def handle_in("biz:category", params, socket) do
    cat = Api.CacheWorker.lookup(Api.CacheWorker, params["id"])

    businesses =
      cat.businesses
      |> Enum.map(fn business ->
        Map.put(business, :online, Helper.online?(business.id, "business"))
      end)

    {:reply, {:ok, %{businesses: businesses}}, socket}
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
      %{"id" => socket.assigns.entity_id}
    )

    {:noreply, socket}
  end

  def handle_in("new:broadcast", %{"category" => category, "text" => text}, socket) do
    user_id = socket.assigns.current_user.id

    broadcast =
      Repo.insert!(%Broadcast{
        category_id: category["id"],
        user_id: user_id,
        text: text
      })
      |> Repo.preload(:category)

    name = category["name"]

    ApiWeb.Endpoint.broadcast(
      "category:#{name}",
      "new:broadcast",
      broadcast
    )

    {:reply, {:ok, broadcast}, socket}
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

  intercept(["new:msg", "typing"])

  def handle_out("new:msg", message, socket) do
    push(socket, "new:msg", message)
    {:noreply, socket}
  end

  def handle_out("typing", payload, socket) do
    push(socket, "typing", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    online_map = Helper.online_map(socket.assigns.tracking_ids, "business")
    # IO.inspect(%{online: online_map, categories: Helper.categories()})
    push(socket, "after:join", %{online: online_map, categories: Helper.categories()})

    {:noreply, socket |> assign(:online_map, online_map)}
  end

  defp authorized?(user_id, socket) do
    socket.assigns.current_user.id == String.to_integer(user_id)
  end
end
