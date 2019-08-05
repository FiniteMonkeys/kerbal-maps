defmodule KerbalMaps.Repo.Migrations.MakeCelestialBodyPlanetPackFKNotNull do
  use Ecto.Migration

  def change do
    alter table(:celestial_bodies) do
      modify :planet_pack_id, :bigint, null: false
    end
  end
end
