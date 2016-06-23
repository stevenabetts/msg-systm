defmodule PanelDemon.Repo.Migrations.CreateProcess do
  use Ecto.Migration

  def change do
    create table(:processes) do
      add :name, :string
      add :is_active, :boolean, default: false
      add :mps, :integer
      add :num_workers, :integer
      add :i_queue, :string
      add :r_queue, :string

      timestamps
    end

  end
end
