defmodule KSPMapsWeb.DataChannel do
  @moduledoc false

  use KSPMapsWeb, :channel

  require Logger

  def join("data:" <> username, _payload, socket) do
    user = KSPMaps.find_user_by_email(username)
    if user do
      {:ok, Phoenix.Socket.assign(socket, :user_id, user.id)}
    else
      {:error, "username #{username} not found"}
    end
  end

  def handle_in("get_data", _payload, socket) do
    user_id = socket.assigns[:user_id]
    user = KSPMaps.get_user(user_id)
    if user do
      {:reply, {:ok, %{data: KSPMaps.Users.User.markers(user)}}, socket}
    else
      {:reply, {:error, "user with id #{user_id} not found"}}
    end
  end
end
