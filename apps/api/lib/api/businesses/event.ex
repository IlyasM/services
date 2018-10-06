defmodule Api.Businesses.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:deleted, :boolean, default: false)
    field(:from_id, :string)
    field(:text, :string)
    field(:to_id, :string)
    field(:type, :string)
    field(:broadcast_id, :string)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:to_id, :from_id, :type, :deleted, :text, :broadcast_id])
    |> validate_required([:to_id, :from_id, :type, :deleted, :text])
  end
end
