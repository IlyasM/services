defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Accounts.{Credential}
  alias Api.Media.UserPhoto
  alias Api.Businesses.{Broadcast}
  @derive {Poison.Encoder, only: [:id, :name, :email, :phone]}

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:verified, :boolean, default: false)

    has_one(:avatar, UserPhoto)
    has_many(:broadcasts, Broadcast)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :phone])
    |> validate_required([:email])
  end
end
