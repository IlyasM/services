defmodule Api.Businesses.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field(:name, :string)
    has_many(:broadcasts, Api.Businesses.Broadcast)

    has_many(
      :businesses,
      Api.Businesses.Business
    )

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
