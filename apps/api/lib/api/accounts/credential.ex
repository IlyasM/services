defmodule Api.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Accounts.{User}

  schema "credentials" do
    field(:phone, :string)
    field(:verified, :boolean, default: false)
    field(:email, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:phone, :email])
    |> validate_required([:phone])
    |> unique_constraint(:phone)
  end
end
