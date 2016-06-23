defmodule PanelDemon.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :status, :boolean, default: false
      add :date, :datetime

      timestamps
    end

  end
end
