defmodule Api.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:to_id, :string)
      add(:from_id, :string)
      add(:type, :string)
      add(:deleted, :boolean, default: false, null: false)
      add(:text, :string)

      timestamps()
    end

    create(index(:events, [:to_id]))
    create(index(:events, [:from_id]))
  end
end
