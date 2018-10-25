defmodule Api.CacheWorker do
  use GenServer
  use ApiWeb, :db

  def start_link() do
    name = __MODULE__
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def new(item) do
    GenServer.cast(__MODULE__, {:new, item})
  end

  def lookup(server, category_id) do
    case :ets.lookup(server, category_id) do
      [{^category_id, result}] -> result
      [] -> :error
    end
  end

  def init(table) do
    :ets.new(table, [:named_table, read_concurrency: true])

    Repo.all(Category)
    |> Repo.preload(businesses: [:category])
    |> Enum.each(fn cat ->
      :ets.insert(table, {cat.id, cat})
    end)

    Repo.all(Business)
    |> Repo.preload(:category)
    |> Enum.each(fn b ->
      :ets.insert(table, {"business:#{b.id}", b})
    end)

    Repo.all(User)
    |> Enum.each(fn u ->
      :ets.insert(table, {"user:#{u.id}", u})
    end)

    {:ok, table}
  end

  def handle_cast({:new, item}, table) do
    case item do
      %Category{id: id} = category ->
        :ets.insert(table, {id, category})

      %Business{category_id: cat_id, id: id} = business ->
        category =
          Repo.get(Category, cat_id) |> Repo.preload(businesses: [:category])

        :ets.insert(table, {cat_id, category})
        :ets.insert(table, {"business:#{id}", business})

      %User{id: id} = user ->
        :ets.insert(table, {id, user})
    end

    {:noreply, table}
  end
end
