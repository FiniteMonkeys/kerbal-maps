defmodule KerbalMaps.Repo.Migrations.CreateOverlays do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:overlays) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      timestamps()
    end

    create index(:overlays, [:user_id])
    create unique_index(:overlays, [:name, :user_id])
  end
end
