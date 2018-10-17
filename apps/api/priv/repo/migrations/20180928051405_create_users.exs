defmodule Api.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:phone, :string)
      add(:email, :string)
      add(:verified, :boolean)
      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
