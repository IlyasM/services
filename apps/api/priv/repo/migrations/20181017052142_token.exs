defmodule Api.Repo.Migrations.Token do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:code, :integer)
      add(:value, :string)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:tokens, [:user_id]))
  end
end
