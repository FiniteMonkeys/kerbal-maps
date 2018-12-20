defmodule KerbalMapsWeb.DataChannel do
  @moduledoc false

  use KerbalMapsWeb, :channel

  require Logger

  def join("data:" <> username, _payload, socket) do
    user = KerbalMaps.find_user_by_email(username)
    if user do
      {:ok, Phoenix.Socket.assign(socket, :user_id, user.id)}
    else
      {:error, "username #{username} not found"}
    end
  end

  def handle_in("get_data", _payload, socket) do
    user_id = socket.assigns[:user_id]
    user = KerbalMaps.get_user(user_id)
    if user do
      markers = KerbalMaps.Symbols.list_markers_for_user(user)
                |> Enum.map(fn m -> to_json(m) end)
      {:reply, {:ok, %{data: markers}}, socket}
    else
      {:reply, {:error, "user with id #{user_id} not found"}}
    end
  end

  defp to_json(%KerbalMaps.Symbols.Marker{} = marker) do
    icon_json = Jason.decode!(marker.icon_name)
    %{
      latitude: marker.latitude,
      longitude: marker.longitude,
      label: "<strong>#{marker.name}</strong><br/>#{marker.description}",
      icon_prefix: Map.get(icon_json, "prefix", ""),
      icon_name: Map.get(icon_json, "name", "?"),
    }
  end
end
