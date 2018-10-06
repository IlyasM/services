defmodule ApiWeb.MessagingTest do
  use ApiWeb.ChannelCase
  use ApiWeb, :db

  setup do
    {_, _, apple, tesla, gulder, alex} = Api.Factory.generate1()
    # connect businesses
    biz_sockets =
      [tesla, gulder, apple]
      |> Enum.map(fn biz ->
        connect(ApiWeb.UserSocket, %{"user_id" => biz.user.id})
      end)
      |> Enum.map(fn {_, socket} -> socket end)

    # connect alex
    {:ok, alex_socket} = connect(ApiWeb.UserSocket, %{"user_id" => alex.id})
    # join businesses
    biz_sockets =
      Enum.zip(biz_sockets, [tesla, gulder, apple])
      |> Enum.map(fn {socket, business} ->
        {:ok, _, socket} =
          subscribe_and_join(socket, "business:#{business.id}", %{
            "last_event_id" => 0,
            "chat_ids" => [alex.id]
          })

        socket
      end)

    # join alex
    {:ok, _, alex_socket} =
      subscribe_and_join(alex_socket, "user:#{alex.id}", %{
        "last_event_id" => 0,
        "chat_ids" => [tesla.id, gulder.id, apple.id]
      })

    {:ok, alex_socket: alex_socket, biz_sockets: biz_sockets, tesla: tesla}
  end

  test "correctly handles messaging offset and online status", %{
    alex_socket: alex_socket,
    biz_sockets: biz_sockets,
    tesla: tesla
  } do
    u1 = alex_socket.assigns.current_user

    ref =
      push(Enum.at(biz_sockets, 0), "new:msg", %{
        text: "hellssdo",
        to_id: "user:#{u1.id}",
        from_id: "business:#{tesla.id}",
        type: "message"
      })

    ref2 =
      push(alex_socket, "new:msg", %{
        text: "bla",
        to_id: "business:#{tesla.id}",
        from_id: "user:#{u1.id}",
        type: "message"
      })

    assert_reply(ref, :ok, biz_socket)
    assert_reply(ref2, :ok, alex_socket)
    assert_push("new:msg", %{text: "bla"})
  end

  test "creates the broadcast and gets reply from business", %{
    alex_socket: alex_socket,
    biz_sockets: biz_sockets,
    tesla: tesla
  } do
    user = alex_socket.assigns.current_user

    ref =
      push(
        alex_socket,
        "new:broadcast",
        %{category: Repo.get_by(Category, name: "Квартиры"), text: "нужен сантехник"}
      )

    assert_reply(ref, :ok, alex_socket)
    assert_push("new:broadcast", %{broadcast: %{text: "нужен сантехник"}})
    assert_push("new:broadcast", %{broadcast: %{text: "нужен сантехник"}})

    tesla_socket = Enum.at(biz_sockets, 0)

    ref2 =
      push(tesla_socket, "new:msg", %{
        to_id: "user:#{user.id}",
        from_id: "business:#{tesla.id}",
        text: "I can help you mate",
        broadcast_id: "1",
        type: "reply"
      })

    assert_reply(ref2, :ok, tesla_socket)
    assert_push("new:msg", %{broadcast_id: "1"})
  end

  test "on leave behavior", %{
    alex_socket: alex_socket,
    biz_sockets: [tesla_sock | _],
    tesla: tesla
  } do
    # leave(alex_socket)

    u1 = alex_socket.assigns.current_user

    ref =
      push(tesla_sock, "new:msg", %{
        text: "bro der",
        to_id: "user:#{u1.id}",
        from_id: "business:#{tesla.id}",
        type: "message"
      })

    assert_reply(ref, :ok, alex_socket)
    assert_push("new:msg", %{text: "bro der"})
  end
end
