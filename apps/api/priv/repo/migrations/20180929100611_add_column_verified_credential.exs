defmodule Api.Repo.Migrations.AddColumnVerifiedCredential do
  use Ecto.Migration

  def change do
    alter table(:credentials) do
      add(:verified, :boolean)
    end
  end
end
