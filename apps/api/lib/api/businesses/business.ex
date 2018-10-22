defmodule Api.Businesses.Business do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Media.BusinessPhoto
  @derive {Poison.Encoder, only: [:id, :name, :short, :long, :category, :online]}

  schema "businesses" do
    field(:long, :string)
    field(:name, :string)
    field(:short, :string)
    field(:calling_phones, {:array, :string})
    field(:operator_ids, {:array, :string})

    has_one(:avatar, BusinessPhoto)

    # has_many(:operators, Api.Accounts.User)
    belongs_to(:user, Api.Accounts.User)

    belongs_to(
      :category,
      Api.Businesses.Category
    )

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [:short, :long, :name, :category_id, :operator_ids, :user_id])
  end
end
