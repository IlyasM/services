defmodule Api.Businesses.Broadcast do
  use Ecto.Schema
  import Ecto.Changeset

  schema "broadcasts" do
    field(:text, :string)
    field(:active, :boolean, default: true)
    belongs_to(:user, Api.Accounts.User)
    belongs_to(:category, Api.Business.Category)

    timestamps()
  end

  @doc false
  def changeset(broadcast, attrs) do
    broadcast
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
