defmodule KerbalMapsWeb.DataChannel do
  @moduledoc false

  use KerbalMapsWeb, :channel

  require Logger

  import ESpec.Testable

  alias KerbalMaps.CoordinateParser
  alias KerbalMaps.StaticData
  alias KerbalMaps.Symbols
  alias KerbalMaps.Symbols.Marker
  alias KerbalMaps.Symbols.Overlay
  alias KerbalMaps.Users
  alias Phoenix.Socket

  def join("data:" <> observed_id, _payload, socket) do
    observed_user = Users.get_user!(String.to_integer(observed_id))

    if observed_user && observed_user.id == socket.assigns[:user_id] do
      ## save user.id under a different key in Socket.assign?
      ## two different uses for "user" here:
      ## 1. the logged-in user (currently stored in socket.assigns[:user_id])
      ## 2. the user whose markers etc. we're interested in (the channel subtopic)
      {:ok, Socket.assign(socket, :observed_id, observed_user.id)}
    else
      {:error, "cannot observe user with id #{observed_id}"}
    end
  end

  def handle_in("get_all_biomes", payload, socket) do
    celestial_body = Map.get(payload, "body") |> StaticData.find_celestial_body_by_name()
    get_all_biomes(celestial_body, socket)
  end

  def handle_in("get_all_overlays", payload, socket) do
    user = socket.assigns[:observed_id] |> Users.get_user()
    celestial_body = Map.get(payload, "body") |> StaticData.find_celestial_body_by_name()
    get_all_overlays(user, celestial_body, socket)
  end

  def handle_in("get_overlay", payload, socket) do
    overlay_id = Map.get(payload, "id")
    overlay = Symbols.get_overlay!(overlay_id) |> to_json()
    {:reply, {:ok, %{overlay: overlay}}, socket}
  end

  def handle_in("parse_search", payload, socket) do
    query = Map.get(payload, "query")

    case CoordinateParser.parse_coordinate(query) do
      [_, _] = location -> {:reply, {:ok, %{location: location}}, socket}
      _ -> {:reply, {:ok, %{error: "bad query #{query}"}}, socket}
    end
  end

  defp get_all_biomes(celestial_body, socket) do
    biomes =
      celestial_body.biome_mapping
      |> Enum.reduce([], fn {label, [r, g, b, a]}, acc -> [%{label: label, r: r, g: g, b: b, a: a} | acc] end)
      |> List.flatten()
      |> Enum.sort_by(fn elem -> elem.label end)

    {:reply, {:ok, %{biomes: biomes}}, socket}
  end

  defp get_all_overlays(_, nil, socket),
    do: {:reply, {:error, "celestial body not found"}, socket}

  defp get_all_overlays(nil, _, socket), do: {:reply, {:error, "user not found"}, socket}

  defp get_all_overlays(user, celestial_body, socket) do
    overlays =
      Symbols.list_overlays_for_user_and_body(user, celestial_body)
      |> Enum.map(&to_json/1)

    {:reply, {:ok, %{overlays: overlays}}, socket}
  end

  defp_testable to_json(%Marker{} = marker) do
    icon_json = Jason.decode!(marker.icon_name)

    %{
      description: marker.description,
      icon_name: Map.get(icon_json, "name", "?"),
      icon_prefix: Map.get(icon_json, "prefix", ""),
      id: marker.id,
      label:
        "<strong>#{marker.name}</strong><br/>#{marker.latitude} #{marker.longitude}<br/>#{
          marker.description
        }",
      latitude: marker.latitude,
      longitude: marker.longitude,
      name: marker.name
    }
  end

  defp_testable to_json(%Overlay{} = overlay) do
    %{
      id: overlay.id,
      name: overlay.name,
      description: overlay.description
    }
    |> load_markers_json(overlay.markers)
  end

  defp load_markers_json(overlay_data, %Ecto.Association.NotLoaded{} = _), do: overlay_data

  defp load_markers_json(overlay_data, markers),
    do: Map.put(overlay_data, :markers, Enum.map(markers, &to_json/1))
end
