defmodule PanelDemon.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :status, :boolean, default: false
      add :delivered_at, :datetime
      add :tags, :map

      timestamps
    end

  end
end
