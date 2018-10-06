defmodule Api.Factory do
  use ApiWeb, :db

  def generate1() do
    users =
      ["Elon", "Steve", "John", "Alex", "Mary", "Malcolm"]
      |> Enum.map(&%User{name: &1})
      |> Enum.map(&Repo.insert!/1)

    [flat, flower] =
      categories =
      ["Квартиры", "Цветы"]
      |> Enum.map(&%Category{name: &1})
      |> Enum.map(&Repo.insert!/1)

    tesla =
      %Business{
        name: "Tesla",
        category_id: flat.id,
        user_id: Enum.at(users, 0).id
      }
      |> Repo.insert!()
      |> Repo.preload(:user)

    apple =
      %Business{
        name: "Apple",
        category_id: flat.id,
        user_id: Enum.at(users, 1).id
      }
      |> Repo.insert!()
      |> Repo.preload(:user)

    gulder =
      %Business{
        name: "Цветы от Розы",
        category_id: flower.id,
        user_id: Enum.at(users, 2).id
      }
      |> Repo.insert!()
      |> Repo.preload(:user)

    alex = Enum.at(users, 3)

    alex_from_biz_events =
      1..10
      |> Enum.map(fn number ->
        Repo.insert!(%Event{
          from_id: "business:#{Enum.random([tesla, apple, gulder]).id}",
          to_id: "user:#{alex.id}",
          text: Integer.to_string(number),
          type: "message"
        })
      end)

    1..2
    |> Enum.map(fn number ->
      Repo.insert!(%Event{
        from_id: "business:#{Enum.random([tesla, apple, gulder]).id}",
        to_id: "user:#{alex.id}",
        text: "delivered",
        type: "status"
      })
    end)

    {users, categories, apple, tesla, gulder, alex}
  end
end
