defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Accounts.{Credential}
  alias Api.Media.UserPhoto
  alias Api.Businesses.{Broadcast}

  schema "users" do
    field(:name, :string)
    has_one(:credential, Credential)
    has_one(:avatar, UserPhoto)
    has_many(:broadcasts, Broadcast)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
