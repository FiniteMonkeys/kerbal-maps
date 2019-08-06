defmodule KerbalMaps.Repo.Migrations.AddBiomeDataColumnToCelestialBodies do
  use Ecto.Migration

  def change do
    alter table(:celestial_bodies) do
      add :biome_mapping, :jsonb, null: false, default: "{}"
    end
  end
end
