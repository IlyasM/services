defmodule Api.Repo.Migrations.CreateBroadcasts do
  use Ecto.Migration

  def change do
    create table(:broadcasts) do
      add(:text, :string)
      add(:active, :boolean)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:category_id, references(:categories, on_delete: :nothing))

      timestamps()
    end

    create(index(:broadcasts, [:user_id]))
    create(index(:broadcasts, [:category_id]))
  end
end
