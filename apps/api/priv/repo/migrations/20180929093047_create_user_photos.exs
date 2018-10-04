defmodule Api.Repo.Migrations.CreateUserPhotos do
  use Ecto.Migration

  def change do
    create table(:user_photos) do
      add(:url, :string)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:user_photos, [:user_id]))
  end
end
