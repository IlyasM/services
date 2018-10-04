defmodule Api.Repo.Migrations.CreateBusinessPhotos do
  use Ecto.Migration

  def change do
    create table(:business_photos) do
      add(:url, :string)
      add(:business_id, references(:businesses, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:business_photos, [:business_id]))
  end
end
