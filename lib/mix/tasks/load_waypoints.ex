defmodule Mix.Tasks.LoadWaypoints do
  @moduledoc """
  A Mix task to load a Waypoints Manager file as a set of markers for a user.
  """

  use Mix.Task

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

    Enum.each(data, fn waypoint -> Marker.load_waypoint(waypoint, for: user) end)
  end
end
