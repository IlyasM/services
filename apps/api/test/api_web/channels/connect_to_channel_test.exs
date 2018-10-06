defmodule ApiWeb.ConnectToChannelTest do
  use ApiWeb.ChannelCase
  use ApiWeb, :db

  setup do
    [u1 | _] =
      users =
      ["John", "Alex", "Mary"]
      |> Enum.map(&%User{name: &1})
      |> Enum.map(&Repo.insert!/1)

    jim = Repo.insert!(%User{name: "Jim"})

    category =
      %Category{name: "Квартиры"}
      |> Repo.insert!()

    category2 =
      %Category{name: "Сантехники"}
      |> Repo.insert!()

    business =
      %Business{name: "Rpc dev", category_id: category.id, user_id: u1.id}
      |> Repo.insert!()

    jim_biz =
      %Business{name: "Bro deva", category_id: category.id, user_id: jim.id}
      |> Repo.insert!()

    {_, jim_socket} = connect(ApiWeb.UserSocket, %{"user_id" => jim.id})

    [john, alex, mary] =
      users
      |> Enum.map(fn user ->
        connect(ApiWeb.UserSocket, %{"user_id" => user.id})
      end)
      |> Enum.map(fn {_, socket} -> socket end)

    {:ok, _, biz_socket} =
      subscribe_and_join(john, "business:#{business.id}", %{
        "last_event_id" => 1,
        "chat_ids" => [1, 2, 3]
      })

    {:ok, _, jim_socket} =
      subscribe_and_join(jim_socket, "business:#{jim_biz.id}", %{
        "last_event_id" => 1,
        "chat_ids" => [1, 2, 3]
      })

    [{:ok, _, alex}, {:ok, _, mary}] =
      [alex, mary]
      |> Enum.map(fn socket ->
        subscribe_and_join(socket, "user:#{socket.assigns.current_user.id}", %{
          "last_event_id" => 1,
          "chat_ids" => [1, 2, 3]
        })
      end)

    {:ok,
     users: users,
     business: business,
     biz_socket: biz_socket,
     alex: alex,
     mary: mary,
     category: category,
     socket: socket}
  end

  test "new message is created correctly", %{
    biz_socket: biz_socket,
    alex: alex,
    mary: mary,
    business: business
  } do
    u1 = alex.assigns.current_user

    ref =
      push(biz_socket, "new:msg", %{
        text: "hello",
        to_id: "user:#{u1.id}",
        from_id: "business:#{business.id}",
        type: "message"
      })

    # :timer.sleep(1000)
    # handle in of Business channel replies with message
    assert_reply(ref, :ok, biz_socket)
    # handle out in user channel pushes down the socket
    assert_push("new:msg", %{type: "message", text: "hello"})
  end

  test "broadcast created correctly", %{alex: alex, category: category, biz_socket: biz_socket} do
    user = alex.assigns.current_user

    ref =
      push(
        alex,
        "new:broadcast",
        %{category: category, text: "нужен сантехник"}
      )

    assert_reply(ref, :ok, alex)

    # ack push of broadcasted message
    assert_push("new:broadcast", %{broadcast: %{text: "нужен сантехник"}})
  end

  # test "join channel for sockets", %{
  #   socket: socket,
  #   users: [u1 | _]
  # } do
  #   topic = "user:#{u1.id}"
  #   IO.inspect(socket)

  #   :ets.lookup(Api.PubSub.Local0, topic)
  #   |> IO.inspect()

  #   Phoenix.PubSub.Local.subscribers(Api.PubSub, "user:#{u1.id}", 0)
  #   |> IO.inspect()

  #   :timer.sleep(1000)
  # end
end
