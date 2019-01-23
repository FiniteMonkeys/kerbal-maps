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
alias KerbalMaps.Symbols
alias KerbalMaps.Symbols.Marker
alias KerbalMaps.Symbols.Overlay
alias KerbalMaps.Users.User

defmodule KerbalMaps.Seeds do
  @moduledoc false

  def insert_marker(params) do
    icon_glyph = Keyword.get(params, :icon, "exclamation")
    icon_prefix = Keyword.get(params, :icon_prefix, "fas")
    Repo.insert!(%Marker{
      name: Keyword.fetch!(params, :name),
      description: Keyword.get(params, :description),
      latitude: Keyword.fetch!(params, :latitude),
      longitude: Keyword.fetch!(params, :longitude),
      altitude: Keyword.get(params, :altitude),
      navigation_uuid: Keyword.get(params, :navigation_uuid),
      icon_name: ~s({"prefix":"#{icon_prefix}","name":"#{icon_glyph}"}),
      user_id: Keyword.fetch!(params, :user).id,
      celestial_body_id: Keyword.fetch!(params, :body).id,
    } |> Marker.changeset(%{}) |> Ecto.Changeset.apply_changes())
  end
  def insert_anomaly_marker(params), do: Keyword.put_new(params, :icon, "question-circle") |> insert_marker()
  def insert_city_marker(params), do: Keyword.put_new(params, :icon, "city") |> insert_marker()
  def insert_compass_marker(params), do: Keyword.put_new(params, :icon, "compass") |> insert_marker()
  def insert_dish_marker(params), do: Keyword.put_new(params, :icon, "satellite-dish") |> insert_marker()
  def insert_helipad_marker(params), do: Keyword.put_new(params, :icon, "helicopter") |> insert_marker()
  def insert_highest_point_marker(params), do: Keyword.put_new(params, :icon, "chevron-circle-up") |> insert_marker()
  def insert_launchsite_marker(params), do: Keyword.put_new(params, :icon, "rocket") |> insert_marker()
  def insert_lowest_point_marker(params), do: Keyword.put_new(params, :icon, "chevron-circle-down") |> insert_marker()
  def insert_mountain_marker(params), do: Keyword.put_new(params, :icon, "mountain") |> insert_marker()
  def insert_runway_marker(params), do: Keyword.put_new(params, :icon, "plane") |> insert_marker()

  def insert_overlay(params) do
    Repo.insert!(%Overlay{
      name: Keyword.fetch!(params, :name),
      description: Keyword.get(params, :description),
      user_id: Keyword.fetch!(params, :user).id,
      celestial_body_id: Keyword.fetch!(params, :body).id,
    } |> Overlay.changeset(%{}) |> Ecto.Changeset.apply_changes())
  end

  def add_marker(overlay, marker_name) do
    marker = Symbols.find_marker_by_name(marker_name, %{"user_id" => overlay.user_id, "celestial_body_id" => overlay.celestial_body_id})
    Repo.query!(
      "INSERT INTO overlays_markers (overlay_id, marker_id, user_id, celestial_body_id, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6)",
      [overlay.id, marker.id, overlay.user_id, overlay.celestial_body_id, DateTime.utc_now(), DateTime.utc_now()]
    )
    overlay
  end
end
alias KerbalMaps.Seeds

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

me = Repo.insert!(%User{
  email: "craig@cottingham.net",
  password_hash: "$pbkdf2-sha512$100000$23m4rdSBgJ9GxRzyf/lX6g==$AcaQXaLgcubwmcbvHR0UfQIlv4SHDcVC6N/X9arZgftPACjBPqSbTFGMCrLYi8W1QZ7UHlQc7UlBk+xJrAIDQQ==",
  email_confirmation_token: "fdf5593d-b5f2-4c7a-93f7-4efd9ce3f233",
  email_confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
  unconfirmed_email: nil,
} |> User.changeset(%{}) |> Ecto.Changeset.apply_changes())

## Symbols

##   Markers

##     Anomalies

Seeds.insert_anomaly_marker(name: "Northern Sinkhole",      latitude:  90.000000, longitude:    0.000000, user: me, body: moho, navigation_uuid: "0614db8a-7fab-48e6-874f-dc2c7d8e900d")

Seeds.insert_anomaly_marker(name: "Baikerbanur Monolith",   latitude:  20.670895, longitude: -146.496854, user: me, body: kerbin, navigation_uuid: "5ce4f5b1-e46e-4538-ab9a-32c4f82fc413")
Seeds.insert_anomaly_marker(name: "Crashed Saucer",         latitude:  81.955167, longitude: -128.517573, user: me, body: kerbin, navigation_uuid: "1e8b1906-b7b6-484f-8775-ee92c0744be4")
Seeds.insert_anomaly_marker(name: "Eastern Monolith",       latitude: -28.808300, longitude:  -13.440100, user: me, body: kerbin, navigation_uuid: "1d620c17-aa6f-4492-bdb7-b72d01adae00")
Seeds.insert_anomaly_marker(name: "Hidden Valley Monolith", latitude:  35.570511, longitude:  -74.977287, user: me, body: kerbin, navigation_uuid: "4d433a4d-60e1-42d6-b92e-424005c34705")
Seeds.insert_anomaly_marker(name: "KSC Monolith",           latitude:   0.102330, longitude:  -74.568421, user: me, body: kerbin, navigation_uuid: "c1dbd986-6335-4cdb-91f3-557efeb9815b")
Seeds.insert_anomaly_marker(name: "Smiley Face",            latitude: -30.000000, longitude:  -80.000000, user: me, body: kerbin, navigation_uuid: "66652944-f478-430f-87a3-48b1fd658d19")
Seeds.insert_anomaly_marker(name: "Tut-Ur Jeb-Ahn",         latitude:  -6.505657, longitude: -141.685615, user: me, body: kerbin, navigation_uuid: "963243d9-2f0b-47c1-8f6a-e73efeea4436")
Seeds.insert_anomaly_marker(name: "Western Monolith",       latitude:  -0.640111, longitude:  -80.766738, user: me, body: kerbin, navigation_uuid: "a6803f1b-ca9a-43e9-98bd-b6cb321f6ab6")

Seeds.insert_anomaly_marker(name: "Armstrong Monument",     latitude:   0.702700, longitude:   22.747000, user: me, body: mun, navigation_uuid: "85b49f1e-7576-4c77-bb90-85b3ac62c91c")
Seeds.insert_anomaly_marker(name: "Crashed Saucer",         latitude: -70.955600, longitude:  -68.137800, user: me, body: mun, navigation_uuid: "abe0c9a8-650f-4679-b875-d1fd19f68caf")
Seeds.insert_anomaly_marker(name: "East Crater Arch",       latitude:   2.469500, longitude:   81.513300, user: me, body: mun, navigation_uuid: "d99b0e30-60ba-4bfb-ab4f-5fc2c66c8926")
Seeds.insert_anomaly_marker(name: "East Farside Arch",      latitude: -12.443100, longitude: -140.822000, user: me, body: mun, navigation_uuid: "aa547350-8932-4053-a8d6-900f5638869d")
Seeds.insert_anomaly_marker(name: "Nearside Monolith",      latitude:  -9.831400, longitude:   25.917000, user: me, body: mun, navigation_uuid: "6f063b5f-02a9-4e98-9422-ff2f679cb8d8")
Seeds.insert_anomaly_marker(name: "Northern Monolith",      latitude:  57.660400, longitude:    9.142200, user: me, body: mun, navigation_uuid: "507bb506-4456-49c1-9579-cd1790bc463b")
Seeds.insert_anomaly_marker(name: "Northwest Crater Arch",  latitude:  12.443200, longitude:   39.178000, user: me, body: mun, navigation_uuid: "dce9943e-f7cf-4774-ab16-d156b2b0da87")
Seeds.insert_anomaly_marker(name: "South Polar Monolith",   latitude: -82.206300, longitude:  102.930500, user: me, body: mun, navigation_uuid: "0a319114-cc2d-4e6d-9902-7f64b8e68830")

Seeds.insert_anomaly_marker(name: "Monolith",               latitude:  23.776800, longitude:   60.046200, user: me, body: minmus, navigation_uuid: "fbf3d06b-3376-4af3-a102-d95f4534096c")

Seeds.insert_anomaly_marker(name: "Alien Camera",           latitude: -30.352500, longitude:  -28.682800, user: me, body: duna, navigation_uuid: "02334b66-5cd6-4a41-83b7-055627e944ba")
Seeds.insert_anomaly_marker(name: "Cyduna Face",            latitude:  17.048300, longitude:  -85.471700, user: me, body: duna, navigation_uuid: "6b27e7ed-a143-47f0-a8a4-196083383aab")
Seeds.insert_anomaly_marker(name: "SSTV Hill",              latitude: -66.134400, longitude: -160.743200, user: me, body: duna, navigation_uuid: "201424b1-dda6-45e6-947e-b8e35e9794ba")

Seeds.insert_anomaly_marker(name: "Vallhenge",              latitude: -60.328900, longitude:   84.057900, user: me, body: vall, navigation_uuid: "e125af95-0f29-4a2d-8b30-3b774771a5e2")

Seeds.insert_anomaly_marker(name: "Cave",                   latitude:  40.267100, longitude:  174.046700, user: me, body: tylo, navigation_uuid: "12910cef-d4a3-466e-b96f-90d190566dd2")

Seeds.insert_anomaly_marker(name: "Large Orange Circle",    latitude:   4.740000, longitude:  -72.770000, user: me, body: bop, navigation_uuid: "7d860c42-e129-4efa-875f-df496be98762")
Seeds.insert_anomaly_marker(name: "Space Kraken",           latitude:  60.435556, longitude:  117.025278, user: me, body: bop, navigation_uuid: "cedb4799-9cf7-4629-9f41-bcc47b733247")

##     Cities

Seeds.insert_city_marker(name: "Hom",    latitude:  35.332031, longitude: -175.297852, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 2", latitude:  47.900391, longitude: -215.639648, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 3", latitude:   9.426270, longitude: -274.262695, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 4", latitude: -37.089844, longitude: -284.545898, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 5", latitude: -19.116211, longitude: -288.764648, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 6", latitude: -42.539062, longitude: -311.198730, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 7", latitude: -11.052246, longitude: -203.554687, user: me, body: kerbin)
# Seeds.insert_city_marker(name: "City 8", latitude: -13.842773, longitude: -161.894531, user: me, body: kerbin)

##     Tracking Stations

Seeds.insert_dish_marker(name: "Baikerbanur Tracking Station",       latitude:  20.681019, longitude: -146.501462, user: me, body: kerbin, navigation_uuid: "ec0d87b9-4371-42d1-8bc1-0031b17fcf4e")
Seeds.insert_dish_marker(name: "Crater Rim Tracking Station",        latitude:   9.450058, longitude: -172.110066, user: me, body: kerbin, navigation_uuid: "d2f734ce-52f3-4dff-9d04-3b51940fb877")
Seeds.insert_dish_marker(name: "Harvester Massif Tracking Station",  latitude: -11.950104, longitude:   33.740040, user: me, body: kerbin, navigation_uuid: "60053bff-d21f-4570-b8b3-e73cfea1bf26")
Seeds.insert_dish_marker(name: "Mesa South Tracking Station",        latitude: -59.590011, longitude:  -25.869794, user: me, body: kerbin, navigation_uuid: "e3b35deb-8fe5-4864-8d27-1698097b98f3")
Seeds.insert_dish_marker(name: "North Station One Tracking Station", latitude:  63.095084, longitude:  -90.079893, user: me, body: kerbin, navigation_uuid: "80698255-4e2f-4c14-88d5-7a0faeca3ab9")
Seeds.insert_dish_marker(name: "Nye Island Tracking Station",        latitude:   5.359932, longitude:  108.549921, user: me, body: kerbin, navigation_uuid: "29502e94-2f35-4163-aa39-6a4fcef970a7")
Seeds.insert_dish_marker(name: "Woomerang Tracking Station",         latitude:  44.720016, longitude:  137.029844, user: me, body: kerbin, navigation_uuid: "5049d71c-6976-4bea-bb6b-7b2049a63845")
Seeds.insert_dish_marker(name: "KSC Tracking Station",               latitude:  -0.124433, longitude:  285.396239, user: me, body: kerbin, navigation_uuid: "a7c5d8a6-1028-4c73-af63-c406d3e6cbf6")

##     Maxima and minima

Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude:  54.679000, longitude:  153.490000, user: me, body: moho, navigation_uuid: "3531bbc3-f488-457b-9ea4-406a919ffeb8")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude: -19.654500, longitude: -166.234100, user: me, body: moho, navigation_uuid: "362860d0-ebc4-4c49-b32b-e8ef4d2a3eef")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -25.015900, longitude: -158.455800, user: me, body: eve, navigation_uuid: "df42fa13-cb8e-4306-a7cb-6f81bc5787ca")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude: -44.747300, longitude: -107.852800, user: me, body: eve, navigation_uuid: "43ef7049-05aa-49bf-8010-6d68dd0863ae")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -29.256600, longitude: -123.870800, user: me, body: gilly, navigation_uuid: "986c230f-10ec-40e1-82b6-bd085acac186")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  56.788300, longitude:   -7.240000, user: me, body: gilly, navigation_uuid: "78240bc6-495d-4791-8772-7ad64876ebf7")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude:  61.578400, longitude:   46.373300, user: me, body: kerbin, navigation_uuid: "d782c960-172d-4d5a-8743-9548c8a55e86")
Seeds.insert_lowest_point_marker(name:  "Deepest Depth",     latitude: -28.905000, longitude:  -83.111600, user: me, body: kerbin, navigation_uuid: "78bfd3da-a544-40bd-aecd-d61c24dde4aa")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -82.518300, longitude: -152.325400, user: me, body: mun, navigation_uuid: "82927aae-3d08-4419-874b-544e45d547af")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  35.321000, longitude:  -76.629600, user: me, body: mun, navigation_uuid: "14ae4a01-9d7a-494e-9d9b-e6dd8e721148")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -62.929700, longitude:   74.729000, user: me, body: minmus, navigation_uuid: "d3e788c7-3a91-4d51-b35b-501cdc1c7a74")
# Seeds.insert_lowest_point_marker(name: "Lowest Elevation", latitude: , longitude: , user: me, body: minmus, navigation_uuid: "")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude:  20.885000, longitude: -106.798100, user: me, body: duna, navigation_uuid: "a864de06-27fe-452f-bf34-981b2113ae73")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  -5.943600, longitude:  -50.548100, user: me, body: duna, navigation_uuid: "ae709377-a5cb-4b4f-b667-ba529cc7e253")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude:  25.279500, longitude:  178.297100, user: me, body: ike, navigation_uuid: "217d4365-f02c-4c2a-848e-ad5c75bf63b1")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude: -14.425000, longitude:   25.455300, user: me, body: ike, navigation_uuid: "13426c20-bbb6-46dc-801b-b9bb60a588c4")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -85.001200, longitude:   42.637900, user: me, body: dres, navigation_uuid: "ca6e0206-e362-4b86-b55c-99480126b562")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  19.017330, longitude:  -57.139900, user: me, body: dres, navigation_uuid: "5bfc97f3-4d57-453d-916a-5a5a5f92b57c")
# jool doesn't have a surface
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -17.589100, longitude:  172.584200, user: me, body: laythe, navigation_uuid: "b658c0e4-a5b3-4264-99dd-7432eee05018")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  29.454300, longitude:    7.349900, user: me, body: laythe, navigation_uuid: "c76bb712-b752-4c4a-86fd-0cf2a4bbfed9")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -57.491500, longitude: -144.459200, user: me, body: vall, navigation_uuid: "21dfc4a1-43ed-4612-92df-eb181282f1c1")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  11.634500, longitude:  145.491900, user: me, body: vall, navigation_uuid: "cf72209a-2994-42af-a970-49182ecae345")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -51.778600, longitude:   20.577400, user: me, body: tylo, navigation_uuid: "5a6fce06-63df-47b9-ad8f-a5a43a817570")
# Seeds.insert_lowest_point_marker(name: "Lowest Elevation", latitude: , longitude: , user: me, body: tylo, navigation_uuid: "")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude:  23.873300, longitude:  -64.566700, user: me, body: bop, navigation_uuid: "96f0dd67-ecb0-43b4-aedb-5f8419c8362c")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  37.584200, longitude: -139.273700, user: me, body: bop, navigation_uuid: "82bf0ff5-1117-483e-a0a2-7627b49f69c2")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude: -62.830800, longitude:  164.586200, user: me, body: pol, navigation_uuid: "e6fbae07-f2ba-4ab8-bd60-44b7b6398c39")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude: -25.125700, longitude:  173.770800, user: me, body: pol, navigation_uuid: "cf7e900b-4995-4ffe-b801-64dc9e8bbcfc")
Seeds.insert_highest_point_marker(name: "Highest Elevation", latitude:  24.334700, longitude:   27.960200, user: me, body: eeloo, navigation_uuid: "8c40f4bc-513c-4b26-a4ff-bc53e5d2975b")
Seeds.insert_lowest_point_marker(name:  "Lowest Elevation",  latitude:  51.778600, longitude:  -32.288800, user: me, body: eeloo, navigation_uuid: "afca125c-6590-4206-9858-2597fd7cb16e")

##     Highest peaks on Kerbin

# Seeds.insert_mountain_marker(name: "K1",  latitude:  61.598333, longitude:  46.338056, user: me, body: kerbin, navigation_uuid: "f14b8143-25df-45a1-8dc4-6a09f3fa9f98")
# Seeds.insert_mountain_marker(name: "K2",  latitude: -74.395278, longitude: -17.529722, user: me, body: kerbin, navigation_uuid: "e0951569-c5cb-4c9e-975f-f1acfec4c0ca")
# Seeds.insert_mountain_marker(name: "K3",  latitude: -14.445556, longitude:  71.956667, user: me, body: kerbin, navigation_uuid: "91259f73-bc75-41c2-8495-342bf22693b6")
# Seeds.insert_mountain_marker(name: "K4",  latitude:  -6.598333, longitude: 113.622500, user: me, body: kerbin, navigation_uuid: "88f54b90-4dc6-41d5-87f1-e4dc420b9f96")
# Seeds.insert_mountain_marker(name: "K5",  latitude: -13.830000, longitude:  71.293611, user: me, body: kerbin, navigation_uuid: "9c9dfe1b-586f-4428-8a20-c36bc70444d8")
# Seeds.insert_mountain_marker(name: "K6",  latitude: -30.155278, longitude: -13.455556, user: me, body: kerbin, navigation_uuid: "e8c1d29b-bf5f-4c54-a3e7-d803ad3435a9")
# Seeds.insert_mountain_marker(name: "K7",  latitude:  46.079167, longitude: 139.533611, user: me, body: kerbin, navigation_uuid: "e73d15e2-a696-4e9f-b243-7623df06b379")
# Seeds.insert_mountain_marker(name: "K8",  latitude: -68.553333, longitude: -27.220000, user: me, body: kerbin, navigation_uuid: "e5a67fbd-8cdc-4235-bdd8-096156a390de")
# Seeds.insert_mountain_marker(name: "K9",  latitude: -17.204167, longitude:  73.641667, user: me, body: kerbin, navigation_uuid: "1f2e4e11-69bf-4a5a-a9fc-ebf7933f79a2")
# Seeds.insert_mountain_marker(name: "K10", latitude:  42.552778, longitude: 135.845833, user: me, body: kerbin, navigation_uuid: "302b87b8-7114-4d26-8948-ff36025cb609")

##     Waypoints

# Seeds.insert_compass_marker(name: "ARLO",         latitude: -5.423089, longitude:  175.737944, altitude:  2_500, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "BLADE",        latitude: 39.328112, longitude: -132.322886, altitude:  4_500, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "BONZO",        latitude:  1.404013, longitude:  -76.876363, altitude:  5_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "BURBANK",      latitude: -0.605512, longitude: -175.990001, altitude:  5_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "CAMEL",        latitude: -2.000000, longitude:  -70.750000, altitude:  5_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "CHELNY",       latitude: 14.005054, longitude:  -65.410214, altitude:  3_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "CUTIE",        latitude:  8.500000, longitude:  -99.000000, altitude: 10_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "DODAH",        latitude: -2.000000, longitude:  -78.500000, altitude: 15_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "DOGMA",        latitude:  0.000000, longitude:  -88.000000, altitude: 18_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "DONUT",        latitude: -2.000000, longitude:  -74.800000, altitude: 10_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "FISHY",        latitude:  0.000000, longitude:  -95.000000, altitude: 15_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "HIKEY",        latitude: -0.048598, longitude:  -81.250000, altitude: 10_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "LOKEY",        latitude: -0.048598, longitude:  -79.250000, altitude:  6_500, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "MAXKY",        latitude: -0.048598, longitude:  -82.250000, altitude: 12_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "RAZOR",        latitude: 51.715957, longitude: -131.404613, altitude:  4_500, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "STUCCO",       latitude:  5.300515, longitude:  -59.454392, altitude:  6_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "THRED",        latitude: -0.200000, longitude:  -70.750000, altitude:  3_500, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "TOFFEE",       latitude: -1.528949, longitude: -177.561396, altitude:  4_000, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "VIKING",       latitude: -6.478114, longitude:  173.899018, altitude:  4_500, user: me, body: kerbin)

Seeds.insert_compass_marker(name: "KSC 09 IAF",   latitude: -0.048598, longitude:  -77.250000, altitude:  2_500, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "KSC 09 FAF",   latitude: -0.048598, longitude:  -76.100000, altitude:  1_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "KSC 09 FLARE", latitude: -0.048598, longitude:  -74.735954, altitude:     97, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "KSC 09 STOP",  latitude: -0.048598, longitude:  -74.494739, altitude:     67, user: me, body: kerbin)

Seeds.insert_compass_marker(name: "KSC 27 IAF",   latitude: -0.058211, longitude:  -71.750000, altitude:  2_500, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "KSC 27 FAF",   latitude: -0.058211, longitude:  -73.250000, altitude:  1_000, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "KSC 27 FLARE", latitude: -0.050185, longitude:  -74.470000, altitude:    110, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "KSC 27 STOP",  latitude: -0.050185, longitude:  -74.735950, altitude:     67, user: me, body: kerbin)

# Seeds.insert_compass_marker(name: "HOM 08 IAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 08 FAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 08 FLARE", latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "HOM 08 STOP",  latitude: 33.478000, longitude: -172.346000, altitude:      0, user: me, body: kerbin)

# Seeds.insert_compass_marker(name: "HOM 13 IAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 13 FAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 13 FLARE", latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "HOM 13 STOP",  latitude: 33.380000, longitude: -172.441000, altitude:      0, user: me, body: kerbin)

# Seeds.insert_compass_marker(name: "HOM 26 IAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 26 FAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 26 FLARE", latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "HOM 26 STOP",  latitude: 33.438000, longitude: -172.615000, altitude:      0, user: me, body: kerbin)

# Seeds.insert_compass_marker(name: "HOM 31 IAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 31 FAF",   latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
# Seeds.insert_compass_marker(name: "HOM 31 FLARE", latitude:          , longitude:            , altitude:      0, user: me, body: kerbin)
Seeds.insert_compass_marker(name: "HOM 31 STOP",  latitude: 33.527000, longitude: -172.650000, altitude:      0, user: me, body: kerbin)

# Seeds.insert_compass_marker(name: "",   latitude: , longitude: , altitude: , user: me, body: kerbin)

##     Launch Sites

Seeds.insert_launchsite_marker(name: "Baikerbanur Launchpad", latitude: 20.663491, longitude: -146.420990, user: me, body: kerbin, navigation_uuid: "4651d52b-6a9a-4eee-b08c-1ef3bb56e91e")
Seeds.insert_launchsite_marker(name: "Dessert Launchpad",     latitude: -6.560380, longitude: -143.950039, user: me, body: kerbin, navigation_uuid: "9967fdc8-2ccc-486d-a289-d94a4d37d9f3")
Seeds.insert_launchsite_marker(name: "Island Launchsite",     latitude: -1.529276, longitude:  -71.885306, user: me, body: kerbin, navigation_uuid: "bb4d2e1e-1fb0-4d93-b1fc-ff2831454093")
Seeds.insert_launchsite_marker(name: "KSC Launchpad",         latitude: -0.097206, longitude:  -74.557679, user: me, body: kerbin, navigation_uuid: "ec73f087-3cc8-49a7-ab26-6324f491f5e1")
Seeds.insert_launchsite_marker(name: "Woomerang Launchpad",   latitude: 45.290009, longitude:  136.110003, user: me, body: kerbin, navigation_uuid: "48148dd2-e673-4285-aac5-a055b6f411e2")

##     Miscellaneous

Seeds.insert_marker(name: "Dessert Wind Farm", latitude: -6.519497, longitude: -144.070052, user: me, body: kerbin, navigation_uuid: "3fffbfa3-1fc0-419e-bc65-46e9e60e7d72")
Seeds.insert_marker(name: "Spire Summit",      latitude:  0.062761, longitude:  -79.349539, user: me, body: kerbin, navigation_uuid: "04c0866a-8a74-40eb-a248-764e551e6a8a")

##   Overlays

Seeds.insert_overlay(name: "Anomalies", user: me, body: kerbin)
|> Seeds.add_marker("Baikerbanur Monolith")
|> Seeds.add_marker("Crashed Saucer")
|> Seeds.add_marker("Eastern Monolith")
|> Seeds.add_marker("Hidden Valley Monolith")
|> Seeds.add_marker("KSC Monolith")
|> Seeds.add_marker("Smiley Face")
|> Seeds.add_marker("Tut-Ur Jeb-Ahn")
|> Seeds.add_marker("Western Monolith")

Seeds.insert_overlay(name: "Anomalies", user: me, body: mun)
|> Seeds.add_marker("Armstrong Monument")
|> Seeds.add_marker("Crashed Saucer")
|> Seeds.add_marker("East Crater Arch")
|> Seeds.add_marker("East Farside Arch")
|> Seeds.add_marker("Nearside Monolith")
|> Seeds.add_marker("Northern Monolith")
|> Seeds.add_marker("Northwest Crater Arch")
|> Seeds.add_marker("South Polar Monolith")

Seeds.insert_overlay(name: "Anomalies", user: me, body: minmus)
|> Seeds.add_marker("Monolith")

Seeds.insert_overlay(name: "Anomalies", user: me, body: duna)
|> Seeds.add_marker("Alien Camera")
|> Seeds.add_marker("Cyduna Face")
|> Seeds.add_marker("SSTV Hill")

Seeds.insert_overlay(name: "Anomalies", user: me, body: vall)
|> Seeds.add_marker("Vallhenge")

Seeds.insert_overlay(name: "Anomalies", user: me, body: tylo)
|> Seeds.add_marker("Cave")

Seeds.insert_overlay(name: "Anomalies", user: me, body: bop)
|> Seeds.add_marker("Large Orange Circle")
|> Seeds.add_marker("Space Kraken")

Seeds.insert_overlay(name: "Anomalies", user: me, body: moho)
|> Seeds.add_marker("Northern Sinkhole")

Seeds.insert_overlay(name: "Cities", user: me, body: kerbin)
|> Seeds.add_marker("Hom")
# |> Seeds.add_marker("City 2")
# |> Seeds.add_marker("City 3")
# |> Seeds.add_marker("City 4")
# |> Seeds.add_marker("City 5")
# |> Seeds.add_marker("City 6")
# |> Seeds.add_marker("City 7")
# |> Seeds.add_marker("City 8")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: moho)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: eve)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: gilly)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: kerbin)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Deepest Depth")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: mun)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: minmus)
|> Seeds.add_marker("Highest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: duna)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: ike)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: dres)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: laythe)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: vall)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: tylo)
|> Seeds.add_marker("Highest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: bop)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: pol)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

Seeds.insert_overlay(name: "Highest & Lowest Points", user: me, body: eeloo)
|> Seeds.add_marker("Highest Elevation")
|> Seeds.add_marker("Lowest Elevation")

# Seeds.insert_overlay(name: "Highest peaks on Kerbin", user: me, body: kerbin)
# |> Seeds.add_marker("K1")
# |> Seeds.add_marker("K2")
# |> Seeds.add_marker("K3")
# |> Seeds.add_marker("K4")
# |> Seeds.add_marker("K5")
# |> Seeds.add_marker("K6")
# |> Seeds.add_marker("K7")
# |> Seeds.add_marker("K8")
# |> Seeds.add_marker("K9")
# |> Seeds.add_marker("K10")

Seeds.insert_overlay(name: "Launch Sites", user: me, body: kerbin)
|> Seeds.add_marker("Baikerbanur Launchpad")
|> Seeds.add_marker("Dessert Launchpad")
|> Seeds.add_marker("Island Launchsite")
|> Seeds.add_marker("KSC Launchpad")
|> Seeds.add_marker("Woomerang Launchpad")

Seeds.insert_overlay(name: "Orbit to KSC 09", description: "Approach to KSC 09 from space.", user: me, body: kerbin)
|> Seeds.add_marker("MAXKY")
|> Seeds.add_marker("HIKEY")
|> Seeds.add_marker("LOKEY")
|> Seeds.add_marker("KSC 09 IAF")
|> Seeds.add_marker("KSC 09 FAF")
|> Seeds.add_marker("KSC 09 FLARE")
|> Seeds.add_marker("KSC 09 STOP")

Seeds.insert_overlay(name: "KSC ILS 27", description: "Approach to KSC 27.", user: me, body: kerbin)
|> Seeds.add_marker("DONUT")
|> Seeds.add_marker("CAMEL")
|> Seeds.add_marker("THRED")
|> Seeds.add_marker("KSC 27 IAF")
|> Seeds.add_marker("KSC 27 FAF")
|> Seeds.add_marker("KSC 27 FLARE")
|> Seeds.add_marker("KSC 27 STOP")

Seeds.insert_overlay(name: "Orbit to KSC 27", description: "Approach to KSC 27 from space.", user: me, body: kerbin)
|> Seeds.add_marker("MAXKY")
|> Seeds.add_marker("DONUT")
|> Seeds.add_marker("CAMEL")
|> Seeds.add_marker("THRED")
|> Seeds.add_marker("KSC 27 IAF")
|> Seeds.add_marker("KSC 27 FAF")
|> Seeds.add_marker("KSC 27 FLARE")
|> Seeds.add_marker("KSC 27 STOP")

Seeds.insert_overlay(name: "HOM ILS 08", description: "Approach to Hom 08.", user: me, body: kerbin)
# |> Seeds.add_marker("HOM 08 IAF")
# |> Seeds.add_marker("HOM 08 FAF")
# |> Seeds.add_marker("HOM 08 FLARE")
|> Seeds.add_marker("HOM 08 STOP")

Seeds.insert_overlay(name: "HOM ILS 13", description: "Approach to Hom 13.", user: me, body: kerbin)
# |> Seeds.add_marker("HOM 13 IAF")
# |> Seeds.add_marker("HOM 13 FAF")
# |> Seeds.add_marker("HOM 13 FLARE")
|> Seeds.add_marker("HOM 13 STOP")

Seeds.insert_overlay(name: "HOM ILS 26", description: "Approach to Hom 26.", user: me, body: kerbin)
# |> Seeds.add_marker("HOM 26 IAF")
# |> Seeds.add_marker("HOM 26 FAF")
# |> Seeds.add_marker("HOM 26 FLARE")
|> Seeds.add_marker("HOM 26 STOP")

Seeds.insert_overlay(name: "HOM ILS 31", description: "Approach to Hom 31.", user: me, body: kerbin)
# |> Seeds.add_marker("HOM 31 IAF")
# |> Seeds.add_marker("HOM 31 FAF")
# |> Seeds.add_marker("HOM 31 FLARE")
|> Seeds.add_marker("HOM 31 STOP")

Seeds.insert_overlay(name: "Points of Interest", user: me, body: kerbin)
|> Seeds.add_marker("Dessert Wind Farm")
|> Seeds.add_marker("Spire Summit")


Seeds.insert_launchsite_marker(name: "Central Lakes Launchpad",    latitude: -15.263115, longitude:   91.333550, user: me, body: kerbin, navigation_uuid: "ba2806bd-8b40-4d6b-a0e1-7cc714b55b6a")
Seeds.insert_launchsite_marker(name: "Deadkerbal Pit Launchpad",   latitude:  14.684069, longitude: -127.696494, user: me, body: kerbin, navigation_uuid: "bfaa55cb-f52e-454f-8a39-ee699b7f2306")
Seeds.insert_launchsite_marker(name: "Dull Spot Launchpad",        latitude:  63.883545, longitude: -172.447580, user: me, body: kerbin, navigation_uuid: "18906c47-b761-468d-a23e-3d11e8496078")
Seeds.insert_launchsite_marker(name: "Goldpool Launchpad",         latitude:  -1.109713, longitude:   17.366744, user: me, body: kerbin, navigation_uuid: "f01238ee-74a3-401c-a8de-ee679fb156c8")
Seeds.insert_launchsite_marker(name: "Great Ez Kape Launchpad",    latitude:  20.999837, longitude:  145.872146, user: me, body: kerbin, navigation_uuid: "f8b86498-e378-4780-b797-7d4fdf3740dc")
Seeds.insert_launchsite_marker(name: "Hanbert Cape Launchpad",     latitude: -22.611773, longitude: -140.254620, user: me, body: kerbin, navigation_uuid: "03ee2ac9-9f07-4433-8717-9e625cd2c0fd")
Seeds.insert_launchsite_marker(name: "Kraken's Belly Launchpad",   latitude: -26.707439, longitude:   73.021426, user: me, body: kerbin, navigation_uuid: "1fb5e80a-64df-4911-a2b7-17de3ab62147")
Seeds.insert_launchsite_marker(name: "Mount Snowey Launchpad",     latitude:  20.431281, longitude:  -78.174035, user: me, body: kerbin, navigation_uuid: "4de694a6-d4da-4e27-b6be-24e32c7d9a33")
Seeds.insert_launchsite_marker(name: "Round Range Launchpad",      latitude:  -6.056886, longitude:   99.471426, user: me, body: kerbin, navigation_uuid: "77992ddc-073c-47a0-a727-678bf228bfa7")
Seeds.insert_launchsite_marker(name: "Sanctuary Mouth Launchsite", latitude:  23.681206, longitude:  -39.944186, user: me, body: kerbin, navigation_uuid: "9ec6a741-bc11-46ba-a345-1f93e3f46225")
Seeds.insert_launchsite_marker(name: "Sea's End Launchpad",        latitude: -34.117391, longitude:   79.793564, user: me, body: kerbin, navigation_uuid: "8c2e2d75-db6e-4e2a-8cbc-550e85bb4d3d")
Seeds.insert_launchsite_marker(name: "ZeBeDee Polar Launchpad",    latitude:  78.477094, longitude:  144.899974, user: me, body: kerbin, navigation_uuid: "7b5728a9-a070-481c-ad2c-425805e6186d")
Seeds.insert_runway_marker(name: "Area 110011 Runway",                 latitude:  10.646835, longitude: -132.097291, user: me, body: kerbin, navigation_uuid: "2803b1a3-cf2b-45a3-8941-e7077216ff03")
Seeds.insert_runway_marker(name: "Black Krags Runway",                 latitude:  11.320686, longitude:  -87.687697, user: me, body: kerbin, navigation_uuid: "bb6dc53d-65d7-42d4-91c6-2fd8e25790b5")
Seeds.insert_runway_marker(name: "Coaler Crater Runway",               latitude:  35.429095, longitude:  -98.905491, user: me, body: kerbin, navigation_uuid: "804dd571-e45a-4510-8fc2-dd8d160d5b2a")
Seeds.insert_runway_marker(name: "Dundard's Edge Runway",              latitude:  44.274530, longitude: -132.002872, user: me, body: kerbin, navigation_uuid: "8b6f944d-1bdc-4a2b-899e-87ae7052a188")
Seeds.insert_runway_marker(name: "Green Coast Runway",                 latitude:  -3.492138, longitude:  179.092370, user: me, body: kerbin, navigation_uuid: "78771605-cca8-46cc-a9be-872a2bc1d5b1")
Seeds.insert_runway_marker(name: "Kerbin's Bottom Runway",             latitude: -50.490284, longitude:  170.578136, user: me, body: kerbin, navigation_uuid: "bc0ef711-7c5f-4a3a-a4c2-2f0a5bfd5267")
Seeds.insert_runway_marker(name: "Kerman Lake Runway",                 latitude:  11.278160, longitude:  -63.525867, user: me, body: kerbin, navigation_uuid: "f07c8769-1162-4dcd-83cb-5b12265ec1bd")
Seeds.insert_runway_marker(name: "Lake Dermal Runway",                 latitude:  22.704538, longitude: -120.939775, user: me, body: kerbin, navigation_uuid: "dbc3404a-be76-44c5-ba85-559fa12e4db8")
Seeds.insert_runway_marker(name: "Lodnie Isles Runway",                latitude:  29.738016, longitude:   14.198414, user: me, body: kerbin, navigation_uuid: "984efc52-5a2d-48fe-b042-264969e037d5")
Seeds.insert_runway_marker(name: "Lushlands Runway",                   latitude:   2.156693, longitude:   26.611311, user: me, body: kerbin, navigation_uuid: "14fbc90c-ff39-43cc-b682-08a0053f37f1")
Seeds.insert_runway_marker(name: "Polar Research Centre Runway",       latitude:  79.572570, longitude:  -77.409865, user: me, body: kerbin, navigation_uuid: "ff27e215-deab-434e-aab0-efdcacc883f6")
Seeds.insert_runway_marker(name: "Round Range Runway",                 latitude:  -6.012043, longitude:   99.388893, user: me, body: kerbin, navigation_uuid: "f7c2627c-87b9-47fd-a603-40ce12b29476")
Seeds.insert_runway_marker(name: "South Hope Runway",                  latitude: -49.796363, longitude:   16.994603, user: me, body: kerbin, navigation_uuid: "456541b3-d36a-4d92-9723-2b22ee532166")
Seeds.insert_runway_marker(name: "South Point Runway",                 latitude: -17.820590, longitude:  166.427717, user: me, body: kerbin, navigation_uuid: "81c26221-9ada-402a-a0e5-34a083c676da")
Seeds.insert_runway_marker(name: "South Pole Research Station Runway", latitude: -84.739436, longitude:  142.731308, user: me, body: kerbin, navigation_uuid: "2191e220-5eba-46b0-a5f3-6cbcf542c6ca")
Seeds.insert_runway_marker(name: "The Shelf Runway",                   latitude: -53.816328, longitude: -162.095430, user: me, body: kerbin, navigation_uuid: "38e30094-d082-4c32-9812-2a5a37c78f63")
Seeds.insert_runway_marker(name: "Valentina's Landing Runway",         latitude: -49.594352, longitude:  127.706741, user: me, body: kerbin, navigation_uuid: "c5f068ef-234f-4691-a1c4-c62f8f1bbb63")
Seeds.insert_helipad_marker(name: "Arakebo Observatory Helipad",         latitude:   8.391099, longitude:  179.643728, user: me, body: kerbin, navigation_uuid: "d8d27fe9-e5d5-418d-9efd-41fb5a74874c")
Seeds.insert_helipad_marker(name: "Deadkerbal Pit Helipad",              latitude:  14.804107, longitude: -127.595633, user: me, body: kerbin, navigation_uuid: "2cdd5ba9-99d4-4316-ba2a-169897562971")
Seeds.insert_helipad_marker(name: "Donby Hole Helipad",                  latitude:  13.722677, longitude:   70.402313, user: me, body: kerbin, navigation_uuid: "6c572960-9dea-4fd5-8ff4-4d6f9d0ded1a")
Seeds.insert_helipad_marker(name: "Dundard's Edge Helipad",              latitude:  44.259678, longitude: -132.040921, user: me, body: kerbin, navigation_uuid: "a7319be9-006b-41ed-932e-9b8791b8148f")
Seeds.insert_helipad_marker(name: "Everkrest Helipad",                   latitude: -14.127480, longitude:   71.663340, user: me, body: kerbin, navigation_uuid: "ae77a680-ed4e-4181-9bfb-c66f5b334ae1")
Seeds.insert_helipad_marker(name: "Green Peaks Helipad",                 latitude:  -0.737497, longitude:   74.954648, user: me, body: kerbin, navigation_uuid: "a7ce8fc3-dc94-4a05-97b2-94bcf98ed485")
Seeds.insert_helipad_marker(name: "Guardian's Basin Helipad",            latitude:  42.648595, longitude:  -50.907098, user: me, body: kerbin, navigation_uuid: "689bc2f9-ace0-4f35-8249-845728cddd2b")
Seeds.insert_helipad_marker(name: "Kerbin's Heart Helipad",              latitude:  -6.726013, longitude:   28.595041, user: me, body: kerbin, navigation_uuid: "af70fd08-20fe-4510-b396-5323b8073a9e")
Seeds.insert_helipad_marker(name: "KKVLA Helipad",                       latitude:  10.605792, longitude: -132.267536, user: me, body: kerbin, navigation_uuid: "a9669529-a37f-4e43-9ad4-f2a36b93ae59")
Seeds.insert_helipad_marker(name: "Mount Snowey Helipad",                latitude:  20.413155, longitude:  -78.165486, user: me, body: kerbin, navigation_uuid: "154b858e-ed21-4048-b7e3-be290bcaea23")
Seeds.insert_helipad_marker(name: "North Pole Biodome Helipad",          latitude:  79.557467, longitude:  -77.649501, user: me, body: kerbin, navigation_uuid: "1a8c8601-f7ee-4287-bcbe-5e6685f8dcdd")
Seeds.insert_helipad_marker(name: "Round Range Helipad",                 latitude:  -6.018824, longitude:   99.517894, user: me, body: kerbin, navigation_uuid: "1469ddb1-e654-4a23-a137-6044d6a9e106")
Seeds.insert_helipad_marker(name: "Sandy Island Helipad",                latitude:  -3.233406, longitude:   -7.004770, user: me, body: kerbin, navigation_uuid: "4a3ef469-9d99-40a7-aa36-6e3f0cd346ce")
Seeds.insert_helipad_marker(name: "South Pole Research Station Helipad", latitude: -84.730644, longitude:  142.666122, user: me, body: kerbin, navigation_uuid: "f29a8478-d78f-4ddb-8279-ec522506dec7")
Seeds.insert_marker(name: "Arakebo Island",      latitude:  8.361407, longitude:  179.773504, user: me, body: kerbin, navigation_uuid: "678eb356-89fb-47f1-a69e-84aa9e54ccbf")
Seeds.insert_marker(name: "Black Krags",         latitude: 13.310140, longitude:  -87.128977, user: me, body: kerbin, navigation_uuid: "d1edd577-b0c1-486a-ae3b-598955ad43e6")
Seeds.insert_marker(name: "Blackish Inland Sea", latitude: 51.418354, longitude:  174.712088, user: me, body: kerbin, navigation_uuid: "4655b5ef-5ff0-4e33-9693-3c6f3ddc8b1f")
Seeds.insert_marker(name: "Icefinger Peak",      latitude: 31.392362, longitude:  -41.608742, user: me, body: kerbin, navigation_uuid: "79f05875-122b-4fe7-83ca-247032903804")
Seeds.insert_marker(name: "Jeb's Island Resort", latitude:  6.840033, longitude:  -62.314300, user: me, body: kerbin, navigation_uuid: "dc70bc0d-302e-4627-80ae-345c0020be89")
Seeds.insert_marker(name: "Mount Snowey",        latitude: 20.397879, longitude:  -78.222552, user: me, body: kerbin)
Seeds.insert_marker(name: "The Cut",             latitude: -3.426141, longitude:   19.603990, user: me, body: kerbin, navigation_uuid: "8e0523c4-fc04-4628-b3f1-8f0e79a73c96")
Seeds.insert_marker(name: "Whitish Peaks",       latitude: 60.378968, longitude: -179.211787, user: me, body: kerbin, navigation_uuid: "4c1468ec-38a8-4908-ab27-96713f816b0b")

Seeds.insert_overlay(name: "KerbinSide", user: me, body: kerbin)
|> Seeds.add_marker("Central Lakes Launchpad")
|> Seeds.add_marker("Deadkerbal Pit Launchpad")
|> Seeds.add_marker("Dull Spot Launchpad")
|> Seeds.add_marker("Goldpool Launchpad")
|> Seeds.add_marker("Great Ez Kape Launchpad")
|> Seeds.add_marker("Hanbert Cape Launchpad")
|> Seeds.add_marker("Kraken's Belly Launchpad")
|> Seeds.add_marker("Mount Snowey Launchpad")
|> Seeds.add_marker("Round Range Launchpad")
|> Seeds.add_marker("Sanctuary Mouth Launchsite")
|> Seeds.add_marker("Sea's End Launchpad")
|> Seeds.add_marker("ZeBeDee Polar Launchpad")
|> Seeds.add_marker("Area 110011 Runway")
|> Seeds.add_marker("Black Krags Runway")
|> Seeds.add_marker("Coaler Crater Runway")
|> Seeds.add_marker("Dundard's Edge Runway")
|> Seeds.add_marker("Green Coast Runway")
|> Seeds.add_marker("Kerbin's Bottom Runway")
|> Seeds.add_marker("Kerman Lake Runway")
|> Seeds.add_marker("Lake Dermal Runway")
|> Seeds.add_marker("Lodnie Isles Runway")
|> Seeds.add_marker("Lushlands Runway")
|> Seeds.add_marker("Polar Research Centre Runway")
|> Seeds.add_marker("Round Range Runway")
|> Seeds.add_marker("South Hope Runway")
|> Seeds.add_marker("South Point Runway")
|> Seeds.add_marker("South Pole Research Station Runway")
|> Seeds.add_marker("The Shelf Runway")
|> Seeds.add_marker("Valentina's Landing Runway")
|> Seeds.add_marker("Arakebo Observatory Helipad")
|> Seeds.add_marker("Deadkerbal Pit Helipad")
|> Seeds.add_marker("Donby Hole Helipad")
|> Seeds.add_marker("Dundard's Edge Helipad")
|> Seeds.add_marker("Everkrest Helipad")
|> Seeds.add_marker("Green Peaks Helipad")
|> Seeds.add_marker("Guardian's Basin Helipad")
|> Seeds.add_marker("Kerbin's Heart Helipad")
|> Seeds.add_marker("KKVLA Helipad")
|> Seeds.add_marker("Mount Snowey Helipad")
|> Seeds.add_marker("North Pole Biodome Helipad")
|> Seeds.add_marker("Round Range Helipad")
|> Seeds.add_marker("Sandy Island Helipad")
|> Seeds.add_marker("South Pole Research Station Helipad")
|> Seeds.add_marker("Arakebo Island")
|> Seeds.add_marker("Black Krags")
|> Seeds.add_marker("Blackish Inland Sea")
|> Seeds.add_marker("Icefinger Peak")
|> Seeds.add_marker("Jeb's Island Resort")
|> Seeds.add_marker("Mount Snowey")
|> Seeds.add_marker("The Cut")
|> Seeds.add_marker("Whitish Peaks")
