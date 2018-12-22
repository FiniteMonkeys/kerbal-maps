defmodule KerbalMaps.Repo.Migrations.CreateOverlays do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:overlays) do
      add :name, :string, null: false
      add :description, :text, null: true
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :celestial_body_id, references(:celestial_bodies, on_delete: :nothing), null: false
      timestamps()
    end

    create index(:overlays, [:user_id])
    create index(:overlays, [:celestial_body_id])
    create unique_index(:overlays, [:name, :user_id])
  end
end
