defmodule ApiWeb.ChannelHelper do
  use ApiWeb, :db
  import Ecto.Query

  def events(u_or_b_id, event_id) do
    IO.inspect("here")

    events =
      from(e in Event,
        where: e.to_id == ^u_or_b_id,
        where: e.id > ^event_id,
        order_by: e.inserted_at
      )
      |> Repo.all()

    last_event_id =
      case Enum.take(events, -1) do
        [e] -> e.id
        [] -> event_id
      end

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
        entity =
          Api.CacheWorker.lookup(Api.CacheWorker, ev.from_id)
          |> IO.inspect()

        [prepend, _] =
          ev.from_id
          |> String.split(":")

        category =
          Map.has_key?(entity, :category)
          |> case do
            true -> entity.category
            _ -> nil
          end

        Map.update(
          acc,
          ev.from_id,
          %{
            events: [ev],
            last: ev,
            id: ev.id,
            state: "normal",
            name: entity.name,
            category: category,
            online: online?(entity.id, prepend),
            count: 1
          },
          &%{&1 | events: [ev | &1.events], id: ev.id, last: ev}
        )
      end)

    {messages, statuses, last_event_id}
  end

  def categories do
    Repo.all(Category)
  end

  def biz_category(id) do
    from(b in Business,
      where: b.category_id == ^id
    )
    |> Repo.all()
    |> Repo.preload(:category)
  end

  def online?(id, prepend) do
    case :ets.lookup(Api.PubSub.Local0, "#{prepend}:#{id}") do
      [] -> false
      _ -> true
    end
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

  def msg_bulk(messages) do
    {_, events} = Repo.insert_all(Event, messages, returning: true)
    events
  end
end
