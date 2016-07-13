defmodule PanelDemon.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :status, :boolean, default: false
      add :delivered_at, :datetime, default: Ecto.DateTime.utc

      add :tags, {:array, :string}

      timestamps
    end

  end
end
