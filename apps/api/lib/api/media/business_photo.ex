defmodule Api.Media.BusinessPhoto do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Businesses.Business

  schema "business_photos" do
    field(:url, :string)
    belongs_to(:business, Business)

    timestamps()
  end

  @doc false
  def changeset(business_photo, attrs) do
    business_photo
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
