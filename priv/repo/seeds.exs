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

alias KerbalMaps.Repo
alias KerbalMaps.StaticData.CelestialBody
alias KerbalMaps.Symbols.Marker
alias KerbalMaps.Symbols.Overlay
alias KerbalMaps.Users.User

## StaticData

##   CelestialBody

moho = Repo.insert!(%CelestialBody{name: "Moho"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
eve = Repo.insert!(%CelestialBody{name: "Eve"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  gilly = Repo.insert!(%CelestialBody{name: "Gilly", parent_id: eve.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
kerbin = Repo.insert!(%CelestialBody{name: "Kerbin"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  mun = Repo.insert!(%CelestialBody{name: "Mun", parent_id: kerbin.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  minmus = Repo.insert!(%CelestialBody{name: "Minmus", parent_id: kerbin.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
duna = Repo.insert!(%CelestialBody{name: "Duna"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  ike = Repo.insert!(%CelestialBody{name: "Ike", parent_id: duna.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
dres = Repo.insert!(%CelestialBody{name: "Dres"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
jool = Repo.insert!(%CelestialBody{name: "Jool"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  laythe = Repo.insert!(%CelestialBody{name: "Laythe", parent_id: jool.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  vall = Repo.insert!(%CelestialBody{name: "Vall", parent_id: jool.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  tylo = Repo.insert!(%CelestialBody{name: "Tylo", parent_id: jool.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  bop = Repo.insert!(%CelestialBody{name: "Bop", parent_id: jool.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
  pol = Repo.insert!(%CelestialBody{name: "Pol", parent_id: jool.id} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())
eeloo = Repo.insert!(%CelestialBody{name: "Eeloo"} |> CelestialBody.changeset(%{}) |> Ecto.Changeset.apply_changes())

## Users

##   User

global_user = Repo.insert!(%User{
  id: 0,
  email: "kerbal-maps@finitemonkeys.org",
  password_hash: "$pbkdf2-sha512$100000$62bclBKSz63OphGTINSjfA==$jtFsfNZhzwLmH2MJ9iahkaoucpemV2QFHSz/cfjnXckQUi9OXdbaJaMq0Z9AHJ2a0Qx3l5rOn76DzWTvV/OrXg==",
  email_confirmation_token: "0cd7247b-4631-4b82-9477-1a7d90191cfa",
  email_confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
  unconfirmed_email: nil,
} |> User.changeset_with_user_id(%{}) |> Ecto.Changeset.apply_changes())

## Symbols

##   Markers

##     Anomalies

Marker.insert_anomaly_marker(name: "Northern Sinkhole",      latitude:  90.000000, longitude:    0.000000, user: global_user, body: moho, navigation_uuid: "0614db8a-7fab-48e6-874f-dc2c7d8e900d")

Marker.insert_anomaly_marker(name: "Baikerbanur Monolith",   latitude:  20.670895, longitude: -146.496854, user: global_user, body: kerbin, navigation_uuid: "5ce4f5b1-e46e-4538-ab9a-32c4f82fc413")
Marker.insert_anomaly_marker(name: "Crashed Saucer",         latitude:  81.955167, longitude: -128.517573, user: global_user, body: kerbin, navigation_uuid: "1e8b1906-b7b6-484f-8775-ee92c0744be4")
Marker.insert_anomaly_marker(name: "Eastern Monolith",       latitude: -28.808300, longitude:  -13.440100, user: global_user, body: kerbin, navigation_uuid: "1d620c17-aa6f-4492-bdb7-b72d01adae00")
Marker.insert_anomaly_marker(name: "Hidden Valley Monolith", latitude:  35.570511, longitude:  -74.977287, user: global_user, body: kerbin, navigation_uuid: "4d433a4d-60e1-42d6-b92e-424005c34705")
Marker.insert_anomaly_marker(name: "KSC Monolith",           latitude:   0.102330, longitude:  -74.568421, user: global_user, body: kerbin, navigation_uuid: "c1dbd986-6335-4cdb-91f3-557efeb9815b")
Marker.insert_anomaly_marker(name: "Smiley Face",            latitude: -30.000000, longitude:  -80.000000, user: global_user, body: kerbin, navigation_uuid: "66652944-f478-430f-87a3-48b1fd658d19")
Marker.insert_anomaly_marker(name: "Tut-Ur Jeb-Ahn",         latitude:  -6.505657, longitude: -141.685615, user: global_user, body: kerbin, navigation_uuid: "963243d9-2f0b-47c1-8f6a-e73efeea4436")
Marker.insert_anomaly_marker(name: "Western Monolith",       latitude:  -0.640111, longitude:  -80.766738, user: global_user, body: kerbin, navigation_uuid: "a6803f1b-ca9a-43e9-98bd-b6cb321f6ab6")

Marker.insert_anomaly_marker(name: "Armstrong Monument",     latitude:   0.702700, longitude:   22.747000, user: global_user, body: mun, navigation_uuid: "85b49f1e-7576-4c77-bb90-85b3ac62c91c")
Marker.insert_anomaly_marker(name: "Crashed Saucer",         latitude: -70.955600, longitude:  -68.137800, user: global_user, body: mun, navigation_uuid: "abe0c9a8-650f-4679-b875-d1fd19f68caf")
Marker.insert_anomaly_marker(name: "East Crater Arch",       latitude:   2.469500, longitude:   81.513300, user: global_user, body: mun, navigation_uuid: "d99b0e30-60ba-4bfb-ab4f-5fc2c66c8926")
Marker.insert_anomaly_marker(name: "East Farside Arch",      latitude: -12.443100, longitude: -140.822000, user: global_user, body: mun, navigation_uuid: "aa547350-8932-4053-a8d6-900f5638869d")
Marker.insert_anomaly_marker(name: "Nearside Monolith",      latitude:  -9.831400, longitude:   25.917000, user: global_user, body: mun, navigation_uuid: "6f063b5f-02a9-4e98-9422-ff2f679cb8d8")
Marker.insert_anomaly_marker(name: "Northern Monolith",      latitude:  57.660400, longitude:    9.142200, user: global_user, body: mun, navigation_uuid: "507bb506-4456-49c1-9579-cd1790bc463b")
Marker.insert_anomaly_marker(name: "Northwest Crater Arch",  latitude:  12.443200, longitude:   39.178000, user: global_user, body: mun, navigation_uuid: "dce9943e-f7cf-4774-ab16-d156b2b0da87")
Marker.insert_anomaly_marker(name: "South Polar Monolith",   latitude: -82.206300, longitude:  102.930500, user: global_user, body: mun, navigation_uuid: "0a319114-cc2d-4e6d-9902-7f64b8e68830")

Marker.insert_anomaly_marker(name: "Monolith",               latitude:  23.776800, longitude:   60.046200, user: global_user, body: minmus, navigation_uuid: "fbf3d06b-3376-4af3-a102-d95f4534096c")

Marker.insert_anomaly_marker(name: "Alien Camera",           latitude: -30.352500, longitude:  -28.682800, user: global_user, body: duna, navigation_uuid: "02334b66-5cd6-4a41-83b7-055627e944ba")
Marker.insert_anomaly_marker(name: "Cyduna Face",            latitude:  17.048300, longitude:  -85.471700, user: global_user, body: duna, navigation_uuid: "6b27e7ed-a143-47f0-a8a4-196083383aab")
Marker.insert_anomaly_marker(name: "SSTV Hill",              latitude: -66.134400, longitude: -160.743200, user: global_user, body: duna, navigation_uuid: "201424b1-dda6-45e6-947e-b8e35e9794ba")

Marker.insert_anomaly_marker(name: "Vallhenge",              latitude: -60.328900, longitude:   84.057900, user: global_user, body: vall, navigation_uuid: "e125af95-0f29-4a2d-8b30-3b774771a5e2")

Marker.insert_anomaly_marker(name: "Cave",                   latitude:  40.267100, longitude:  174.046700, user: global_user, body: tylo, navigation_uuid: "12910cef-d4a3-466e-b96f-90d190566dd2")

Marker.insert_anomaly_marker(name: "Large Orange Circle",    latitude:   4.740000, longitude:  -72.770000, user: global_user, body: bop, navigation_uuid: "7d860c42-e129-4efa-875f-df496be98762")
Marker.insert_anomaly_marker(name: "Space Kraken",           latitude:  60.435556, longitude:  117.025278, user: global_user, body: bop, navigation_uuid: "cedb4799-9cf7-4629-9f41-bcc47b733247")

##   Overlays

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: moho)
|> Overlay.add_marker("Northern Sinkhole")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: kerbin)
|> Overlay.add_marker("Baikerbanur Monolith")
|> Overlay.add_marker("Crashed Saucer")
|> Overlay.add_marker("Eastern Monolith")
|> Overlay.add_marker("Hidden Valley Monolith")
|> Overlay.add_marker("KSC Monolith")
|> Overlay.add_marker("Smiley Face")
|> Overlay.add_marker("Tut-Ur Jeb-Ahn")
|> Overlay.add_marker("Western Monolith")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: mun)
|> Overlay.add_marker("Armstrong Monument")
|> Overlay.add_marker("Crashed Saucer")
|> Overlay.add_marker("East Crater Arch")
|> Overlay.add_marker("East Farside Arch")
|> Overlay.add_marker("Nearside Monolith")
|> Overlay.add_marker("Northern Monolith")
|> Overlay.add_marker("Northwest Crater Arch")
|> Overlay.add_marker("South Polar Monolith")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: minmus)
|> Overlay.add_marker("Monolith")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: duna)
|> Overlay.add_marker("Alien Camera")
|> Overlay.add_marker("Cyduna Face")
|> Overlay.add_marker("SSTV Hill")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: vall)
|> Overlay.add_marker("Vallhenge")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: tylo)
|> Overlay.add_marker("Cave")

Overlay.insert_overlay(name: "Anomalies", user: global_user, body: bop)
|> Overlay.add_marker("Large Orange Circle")
|> Overlay.add_marker("Space Kraken")
