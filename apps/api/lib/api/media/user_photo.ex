defmodule Api.Media.UserPhoto do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Accounts.User

  schema "user_photos" do
    field(:url, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(user_photo, attrs) do
    user_photo
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
