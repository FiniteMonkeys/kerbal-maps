defmodule Mix.Tasks.LoadWaypoints do
  @moduledoc """
  A Mix task to load a Waypoints Manager file as a set of markers for a user.


  """

  use Mix.Task

  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData
  alias KerbalMaps.Symbols.Marker
  alias KerbalMaps.Users
  alias KerbalMaps.WaypointsParser

  @shortdoc "Loads waypoints"
  def run([username | filenames]) do
    Mix.Task.run("app.start")

    user = Users.find_user_by_username(username)

    Enum.each(filenames, fn filename -> load_file(filename, for: user) end)
  end

  defp load_file(filename, for: user) when is_binary(filename) do
    IO.puts("loading #{filename} for #{user.email}")

    file = File.open!(filename, [:binary, :read])
    {:ok, data, _} = WaypointsParser.parse({:ok, [], file})
    File.close(file)

    Enum.each(data, fn waypoint -> load_waypoint(waypoint, for: user) end)
  end

  defp load_waypoint(waypoint, for: user) when is_map(waypoint) do
    IO.write(".")

    Repo.insert!(
      %Marker{
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
      }
      |> Marker.changeset(%{})
      |> Ecto.Changeset.apply_changes()
    )
  end

  defp marker_icon("balloon"), do: ~S({"prefix":"far","name":"lightbulb"})

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/arch"),
    do: ~S({"prefix":"fas","name":"archway"})

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/monolith"),
    do: ~S({"prefix":"fas","name":"monument"})

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/pyramids"),
    do: ~S({"prefix":"fas","name":"gopuram"})

  defp marker_icon("ContractPacks/AnomalySurveyor/Icons/unknown"),
    do: ~S({"prefix":"fas","name":"question-circle"})

  defp marker_icon("ContractPacks/Tourism/Icons/Kerbal"), do: ~S({"prefix":"fas","name":"meh"})
  defp marker_icon("dish"), do: ~S({"prefix":"fas","name":"satellite-dish"})
  defp marker_icon("eva"), do: ~S({"prefix":"fas","name":"info"})
  defp marker_icon("gravity"), do: ~S({"prefix":"fas","name":"weight-hanging"})
  defp marker_icon("pressure"), do: ~S({"prefix":"fas","name":"tachometer-alt"})
  defp marker_icon("report"), do: ~S({"prefix":"fas","name":"clipboard"})
  defp marker_icon("seismic"), do: ~S({"prefix":"fas","name":"globe"})
  defp marker_icon("thermometer"), do: ~S({"prefix":"fas","name":"thermometer-half"})

  defp marker_icon(_), do: ~S({"prefix":"fas","name":"question-circle"})
end

# icon = custom
# icon = custom
# icon = dmVessel
