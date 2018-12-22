defmodule KerbalMaps.Repo.Migrations.CreateOverlaysMarkers do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:overlays_markers) do
      add :overlay_id, references(:overlays, on_delete: :nothing), null: false
      add :marker_id, references(:markers, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :celestial_body_id, references(:celestial_bodies, on_delete: :nothing), null: false
      timestamps()
    end

    create index(:overlays_markers, [:overlay_id])
    create index(:overlays_markers, [:marker_id])
    create index(:overlays_markers, [:user_id])
    create index(:overlays_markers, [:celestial_body_id])
  end
end
