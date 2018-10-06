defmodule ApiWeb.ChannelHelper do
  use ApiWeb, :db
  import Ecto.Query

  def events(u_or_b_id, event_id) do
    events =
      from(e in Event,
        where: e.to_id == ^u_or_b_id,
        where: e.id > ^event_id
      )
      |> Repo.all()

    # collapsing statuses
    statuses =
      events
      |> Enum.filter(&(&1.type == "status"))
      |> Enum.reduce(%{}, fn ev, acc ->
        Map.put(acc, ev.from_id, ev)
      end)

    # normalising messages
    messages =
      events
      |> Enum.filter(&(&1.type == "message"))
      |> Enum.reduce(%{}, fn ev, acc ->
        Map.update(acc, ev.from_id, [ev], &[ev | &1])
      end)

    {messages, statuses}
  end

  def online_map(ids, prepend) do
    ids
    |> Enum.reduce(%{}, fn id, acc ->
      online? =
        case :ets.lookup(Api.PubSub.Local0, "#{prepend}:#{id}") do
          [] -> false
          _ -> true
        end

      Map.put(acc, "#{prepend}:#{id}", online?)
    end)
  end

  def new_msg(message) do
    changeset = Event.changeset(%Event{}, message)
    Repo.insert!(changeset)
  end
end
