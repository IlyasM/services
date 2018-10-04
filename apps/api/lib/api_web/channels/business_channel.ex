defmodule ApiWeb.BusinessChannel do
  use ApiWeb, :channel
  alias Phoenix.Socket.Broadcast

  intercept(["shout"])

  def join("business:" <> business_id, _, socket) do
    IO.inspect("joined business")
    {:ok, %{}, socket}
  end

  def handle_in("hehe", payload, socket) do
    IO.inspect("in hehe")
    {:reply, :ok, socket}
  end

  def handle_in(event, payload, socket) do
    IO.inspect("first in handle in business channel")
    IO.inspect(event)
    {:reply, :ok, socket}
  end

  def handle_out(event, payload, socket) do
    IO.puts("in a freaking handle out of business channel")
    push(socket, "hehe", %{})
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
end
