defmodule KerbalMapsWeb.DataChannel do
  @moduledoc false

  use KerbalMapsWeb, :channel

  require Logger

  import ESpec.Testable

  alias KerbalMaps.StaticData
  alias KerbalMaps.Symbols
  alias KerbalMaps.Symbols.Marker
  alias KerbalMaps.Symbols.Overlay
  alias KerbalMaps.Users

  def join("data:" <> user_id, _payload, socket) do
    user = Users.get_user!(String.to_integer(user_id))
    if user do
      {:ok, Phoenix.Socket.assign(socket, :user_id, user.id)}
    else
      {:error, "user with id #{user_id} not found"}
    end
  end

  def handle_in("get_data", _payload, socket) do
    user_id = socket.assigns[:user_id]
    user = Users.get_user!(user_id)
    celestial_body = StaticData.find_celestial_body_by_name("Kerbin")

    if user do
      markers = Symbols.list_markers_for_page(user, celestial_body, %{})
                |> Enum.map(fn m -> to_json(m) end)
      overlays = Symbols.list_overlays_for_page(user, celestial_body, %{})
                 |> Enum.map(fn o -> to_json(o) end)
      {:reply, {:ok, %{markers: markers, overlays: overlays}}, socket}
    else
      {:reply, {:error, "user with id #{user_id} not found"}}
    end
  end

  defp_testable to_json(%Marker{} = marker) do
    icon_json = Jason.decode!(marker.icon_name)
    %{
      id: marker.id,
      latitude: marker.latitude,
      longitude: marker.longitude,
      label: "<strong>#{marker.name}</strong><br/>#{marker.latitude} #{marker.longitude}<br/>#{marker.description}",
      icon_prefix: Map.get(icon_json, "prefix", ""),
      icon_name: Map.get(icon_json, "name", "?"),
    }
  end

  defp_testable to_json(%Overlay{} = overlay) do
    %{
      id: overlay.id,
      name: overlay.name,
      description: overlay.description,
      markers: Enum.map(overlay.markers, fn m -> to_json(m) end),
    }
  end
end
