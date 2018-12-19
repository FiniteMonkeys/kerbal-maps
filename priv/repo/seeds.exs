# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     KerbalMaps.Repo.insert!(%KerbalMaps.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

## StaticData

##   CelestialBody

KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Moho"})
eve = KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Eve"})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Gilly", parent_id: eve.id})
kerbin = KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Kerbin"})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Mun", parent_id: kerbin.id})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Minmus", parent_id: kerbin.id})
duna = KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Duna"})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Ike", parent_id: duna.id})
KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Dres"})
jool = KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Jool"})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Laythe", parent_id: jool.id})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Vall", parent_id: jool.id})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Tylo", parent_id: jool.id})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Bop", parent_id: jool.id})
  KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Pol", parent_id: jool.id})
KerbalMaps.Repo.insert!(%KerbalMaps.StaticData.CelestialBody{name: "Eeloo"})
