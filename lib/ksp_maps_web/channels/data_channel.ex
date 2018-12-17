defmodule KSPMapsWeb.DataChannel do
  @moduledoc false

  use KSPMapsWeb, :channel

  def join("data:" <> _userid, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("get_data", _payload, socket) do
    data = [
      %{latitude: 35.332031, longitude: -175.297852, label: "<strong>City</strong><br />Home"},
      %{latitude:  0.102329, longitude:  -74.568421, label: "<strong>Monolith</strong><br />KSC Monolith"},
    ]
    {:reply, {:ok, %{data: data}}, socket}
  end
end
