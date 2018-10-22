defmodule Api.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:name, :string)
      add(:question, :string)

      timestamps()
    end

    create(unique_index(:categories, [:name]))

    create table(:businesses) do
      add(:short, :string)
      add(:long, :string)
      add(:name, :string)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:category_id, references(:categories, on_delete: :nothing), null: false)
      add(:calling_phones, {:array, :string})
      add(:operator_ids, {:array, :string})

      timestamps
    end

    create(index(:businesses, [:user_id]))
  end
end
