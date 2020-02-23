defmodule KerbalMaps.Symbols.Marker do
  @moduledoc """
  The Marker schema.
  """

  use Ecto.Schema

  require Logger

  import Ecto.Changeset
  import ESpec.Testable

  alias Ecto.Changeset
  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData
  alias KerbalMaps.StaticData.CelestialBody
  alias KerbalMaps.Symbols.Marker
  alias KerbalMaps.Symbols.Overlay
  alias KerbalMaps.Users.User

  schema "markers" do
    field :altitude, :decimal
    field :description, :string
    field :icon_name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :navigation_uuid, Ecto.UUID

    belongs_to :owner, User, foreign_key: :user_id
    belongs_to :celestial_body, CelestialBody
    many_to_many :overlays, Overlay, join_through: "overlays_markers"

    timestamps()
  end

  @doc false
  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [
      :name,
      :description,
      :latitude,
      :longitude,
      :altitude,
      :navigation_uuid,
      :icon_name,
      :user_id,
      :celestial_body_id
    ])
    |> validate_required([:name, :latitude, :longitude, :user_id, :celestial_body_id])
    |> unsafe_validate_unique([:navigation_uuid, :user_id], Repo)
    |> unique_constraint(:navigation_uuid, name: :markers_navigation_uuid_user_id_index)
    |> unsafe_validate_unique([:name, :user_id, :celestial_body_id], Repo)
    |> unique_constraint(:name, name: :markers_name_user_id_celestial_body_id_index)
    |> wrap([:latitude], {-90.000000, 90.000000})
    |> wrap([:longitude], {-180.000000, 180.000000})
  end

  def clamp(changeset, fields, {_min, _max} = range) do
    Enum.reduce(fields, changeset, fn field, cs ->
      put_change(cs, field, clamp(get_field(cs, field), range))
    end)
  end

  defp_testable(clamp(nil, _), do: nil)

  defp_testable(clamp(%Decimal{} = value, {%Decimal{} = min, %Decimal{} = max}),
    do: value |> Decimal.max(min) |> Decimal.min(max)
  )

  defp_testable(clamp(%Decimal{} = value, {min, %Decimal{} = max}) when is_float(min),
    do: clamp(value, {Decimal.from_float(min), max})
  )

  defp_testable(clamp(%Decimal{} = value, {%Decimal{} = min, max}) when is_float(max),
    do: clamp(value, {min, Decimal.from_float(max)})
  )

  defp_testable(clamp(%Decimal{} = value, {min, max}) when is_float(min),
    do: clamp(value, {Decimal.from_float(min), max})
  )

  defp_testable(clamp(%Decimal{} = value, {min, %Decimal{} = max}),
    do: clamp(value, {Decimal.new(min), max})
  )

  defp_testable(clamp(%Decimal{} = value, {%Decimal{} = min, max}),
    do: clamp(value, {min, Decimal.new(max)})
  )

  defp_testable(clamp(%Decimal{} = value, {min, max}), do: clamp(value, {Decimal.new(min), max}))
  defp_testable(clamp(value, {min, _max}) when value < min, do: min)
  defp_testable(clamp(value, {_min, max}) when value > max, do: max)
  defp_testable(clamp(value, _), do: value)

  def wrap(changeset, fields, {_min, _max} = range) do
    Enum.reduce(fields, changeset, fn field, cs ->
      put_change(cs, field, wrap(get_field(cs, field), range))
    end)
  end

  defp_testable(wrap(nil, _), do: nil)

  defp_testable wrap(%Decimal{} = value, {%Decimal{} = min, %Decimal{} = max}) do
    cond do
      Decimal.cmp(value, min) == :lt -> value |> Decimal.add(max) |> Decimal.sub(min)
      Decimal.cmp(value, max) == :gt -> value |> Decimal.add(min) |> Decimal.sub(max)
      true -> value
    end
  end

  defp_testable(wrap(%Decimal{} = value, {min, %Decimal{} = max}) when is_float(min),
    do: wrap(value, {Decimal.from_float(min), max})
  )

  defp_testable(wrap(%Decimal{} = value, {%Decimal{} = min, max}) when is_float(max),
    do: wrap(value, {min, Decimal.from_float(max)})
  )

  defp_testable(wrap(%Decimal{} = value, {min, max}) when is_float(min),
    do: wrap(value, {Decimal.from_float(min), max})
  )

  defp_testable(wrap(%Decimal{} = value, {min, %Decimal{} = max}),
    do: wrap(value, {Decimal.new(min), max})
  )

  defp_testable(wrap(%Decimal{} = value, {%Decimal{} = min, max}),
    do: wrap(value, {min, Decimal.new(max)})
  )

  defp_testable(wrap(%Decimal{} = value, {min, max}), do: wrap(value, {Decimal.new(min), max}))
  defp_testable(wrap(value, {min, max}) when value < min, do: value + max - min)
  defp_testable(wrap(value, {min, max}) when value > max, do: value + min - max)
  defp_testable(wrap(value, _), do: value)

  def load_waypoint(waypoint, for: user) when is_map(waypoint) do
    %Marker{}
    |> Marker.changeset(%{
      name: waypoint["name"],
      description: "",
      latitude: Float.parse(waypoint["latitude"]) |> elem(0),
      longitude: Float.parse(waypoint["longitude"]) |> elem(0),
      altitude: Float.parse(waypoint["altitude"]) |> elem(0),
      navigation_uuid: waypoint["navigationId"],
      icon_name: marker_icon(waypoint["icon"]),
      user_id: user.id,
      celestial_body_id:
        StaticData.find_celestial_body_by_name(waypoint["celestialName"]) |> Map.get(:id, nil)
    })
    # |> Ecto.Changeset.apply_changes
    |> Repo.insert()
  end

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/arch"),
    do: ~S({"prefix":"fas","name":"question-circle"})                                 # fas-archway?

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/monolith"),
    do: ~S({"prefix":"fas","name":"question-circle"})                                 # fas-monument?

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/pyramids"),
    do: ~S({"prefix":"fas","name":"question-circle"})                                 # fas-gopuram?

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/unknown"),
    do: ~S({"prefix":"fas","name":"question-circle"})

  defp marker_icon("ContractPacks/Tourism/Icons/Kerbal"),
    do: ~S({"prefix":"fas","name":"question-circle"})                                 # fas-meh?

  defp marker_icon("balloon"), do: ~S({"prefix":"fas","name":"question-circle"})      # far-lightbulb?
  defp marker_icon("custom"), do: ~S({"prefix":"fas","name":"question-circle"})
  defp marker_icon("dish"), do: ~S({"prefix":"fas","name":"satellite-dish"})
  defp marker_icon("dmVessel"), do: ~S({"prefix":"fas","name":"question-circle"})
  defp marker_icon("eva"), do: ~S({"prefix":"fas","name":"question-circle"})          # fas-info?
  defp marker_icon("gravity"), do: ~S({"prefix":"fas","name":"chevron-circle-up"})    # fas-weight-hanging?
  defp marker_icon("pressure"), do: ~S({"prefix":"fas","name":"chevron-circle-up"})   # fas-tachometer-alt?
  defp marker_icon("report"), do: ~S({"prefix":"fas","name":"question-circle"})       # fas-clipboard?
  defp marker_icon("seismic"), do: ~S({"prefix":"fas","name":"question-circle"})      # fas-globe?
  defp marker_icon("thermometer"), do: ~S({"prefix":"fas","name":"question-circle"})  # fas-thermometer-half?

  defp marker_icon(icon) when is_binary(icon) do
    Logger.warn(fn -> "***** unknown waypoint icon: '#{icon}'" end)
    ~S({"prefix":"fas","name":"question-circle"})
  end

  def insert_marker(params) do
    icon_glyph = Keyword.get(params, :icon, "exclamation")
    icon_prefix = Keyword.get(params, :icon_prefix, "fas")

    Repo.insert!(
      %Marker{
        name: Keyword.fetch!(params, :name),
        description: Keyword.get(params, :description),
        latitude: Keyword.fetch!(params, :latitude),
        longitude: Keyword.fetch!(params, :longitude),
        altitude: Keyword.get(params, :altitude),
        navigation_uuid: Keyword.get(params, :navigation_uuid),
        icon_name: ~s({"prefix":"#{icon_prefix}","name":"#{icon_glyph}"}),
        user_id: Keyword.fetch!(params, :user).id,
        celestial_body_id: Keyword.fetch!(params, :body).id
      }
      |> Marker.changeset(%{})
      |> Changeset.apply_changes()
    )
  end

  def insert_anomaly_marker(params),
    do: Keyword.put_new(params, :icon, "question-circle") |> insert_marker()

  def insert_city_marker(params), do: Keyword.put_new(params, :icon, "city") |> insert_marker()

  def insert_compass_marker(params),
    do: Keyword.put_new(params, :icon, "compass") |> insert_marker()

  def insert_dish_marker(params),
    do: Keyword.put_new(params, :icon, "satellite-dish") |> insert_marker()

  def insert_helipad_marker(params),
    do: Keyword.put_new(params, :icon, "helicopter") |> insert_marker()

  def insert_highest_point_marker(params),
    do: Keyword.put_new(params, :icon, "chevron-circle-up") |> insert_marker()

  def insert_launchsite_marker(params),
    do: Keyword.put_new(params, :icon, "rocket") |> insert_marker()

  def insert_lowest_point_marker(params),
    do: Keyword.put_new(params, :icon, "chevron-circle-down") |> insert_marker()

  def insert_mountain_marker(params),
    do: Keyword.put_new(params, :icon, "mountain") |> insert_marker()

  def insert_runway_marker(params), do: Keyword.put_new(params, :icon, "plane") |> insert_marker()
end
