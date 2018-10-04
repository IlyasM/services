# defmodule ApiWeb.ConnectToChannelTest do
#   use ApiWeb.ChannelCase
#   use ApiWeb, :db

#   setup do
#     [john | _] =
#       users =
#       ["John", "Alex", "Mary"]
#       |> Enum.map(&%User{name: &1})
#       |> Enum.map(&Repo.insert!/1)

#     category =
#       %Category{name: "Квартиры"}
#       |> Repo.insert!()

#     business =
#       %Business{name: "Rpc dev", category_id: category.id, user_id: john.id}
#       |> Repo.insert!()

#     sockets =
#       users
#       |> Enum.map(fn user ->
#         connect(ApiWeb.UserSocket, %{"user_id" => user.id})
#       end)
#       |> Enum.map(fn {_, socket} -> socket end)

#     business_socket = %Phoenix.Socket{Enum.at(sockets, 0) | topic: "business:#{business.id}"}

#     {:ok, sockets: sockets, users: users, business: business, business_socket: business_socket}
#   end

#   test "join channel for sockets", %{
#     sockets: [socket | sockets],
#     users: [john | users],
#     business: business,
#     business_socket: business_socket
#   } do
#     {:ok, _, john} =
#       subscribe_and_join(socket, "user:#{john.id}", %{
#         "mode" => "business",
#         "meta" => %{"business_id" => business.id}
#       })

#     [alex, mary] =
#       Enum.zip(sockets, users)
#       |> Enum.map(
#         &subscribe_and_join(elem(&1, 0), "user:#{elem(&1, 1).id}", %{
#           "mode" => "private",
#           "meta" => %{"business_id" => business.id}
#         })
#       )

#     john = %Phoenix.Socket{
#       john
#       | topic: "business:#{business.id}"
#     }

#     # IO.inspect(john)

#     # ref = push(john, "haha", %{"hello" => "world"})
#     # assert_reply(ref, :ok, %{"hello" => "world"})
#     # broadcast_from(john, "haha", %{"hello" => "world"})
#     # :timer.sleep(1000)
#     # ref =
#   end

# end
