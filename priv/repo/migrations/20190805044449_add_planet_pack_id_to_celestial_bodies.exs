defmodule KerbalMaps.Repo.Migrations.AddPlanetPackIDToCelestialBodies do
  use Ecto.Migration

  import Ecto.Query, warn: false

  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData.{CelestialBody,PlanetPack}

  def change do
    alter table(:celestial_bodies) do
      add :planet_pack_id, references(:planet_packs), null: true
    end

    flush()

    stock_pack =
      PlanetPack
      |> where(fragment("name = '(stock)'"))
      |> Repo.one!

    KerbalMaps.Repo.update_all(CelestialBody, set: [planet_pack_id: stock_pack.id])
  end
end
