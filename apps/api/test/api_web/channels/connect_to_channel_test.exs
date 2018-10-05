defmodule ApiWeb.ConnectToChannelTest do
  use ApiWeb.ChannelCase
  use ApiWeb, :db

  setup do
    [john | _] =
      users =
      ["John", "Alex", "Mary"]
      |> Enum.map(&%User{name: &1})
      |> Enum.map(&Repo.insert!/1)

    category =
      %Category{name: "Квартиры"}
      |> Repo.insert!()

    business =
      %Business{name: "Rpc dev", category_id: category.id, user_id: john.id}
      |> Repo.insert!()

    sockets =
      users
      |> Enum.map(fn user ->
        connect(ApiWeb.UserSocket, %{"user_id" => user.id})
      end)
      |> Enum.map(fn {_, socket} -> socket end)

    business_socket = %Phoenix.Socket{Enum.at(sockets, 0) | topic: "business:#{business.id}"}

    {:ok, _, socket} =
      subscribe_and_join(Enum.at(sockets, 0), "user:#{john.id}", %{
        "last_event_id" => 1,
        "chat_ids" => [1, 2, 3]
      })

    {:ok, _, socket} =
      subscribe_and_join(Enum.at(sockets, 0), "user:#{john.id}", %{
        "last_event_id" => 1,
        "chat_ids" => [1, 2, 3]
      })

    {:ok,
     sockets: sockets,
     users: users,
     business: business,
     business_socket: business_socket,
     socket: socket}
  end

  test "join channel for sockets", %{
    socket: socket,
    users: [u1 | _]
  } do
    topic = "user:#{u1.id}"
    IO.inspect(socket)

    :ets.lookup(Api.PubSub.Local0, topic)
    |> IO.inspect()

    Phoenix.PubSub.Local.subscribers(Api.PubSub, "user:#{u1.id}", 0)
    |> IO.inspect()

    :timer.sleep(1000)
  end
end
