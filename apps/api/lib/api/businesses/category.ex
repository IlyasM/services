defmodule Api.Businesses.Category do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Poison.Encoder, only: [:id, :name, :question]}
  schema "categories" do
    field(:name, :string)
    field(:question, :string)
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
    |> cast(attrs, [:name, :question])
    |> validate_required([:name])
  end
end
