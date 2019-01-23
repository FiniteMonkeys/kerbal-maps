defmodule KerbalMapsWeb.UserSocket do
  @moduledoc """

  """

  use Phoenix.Socket

  ## Channels
  # channel "room:*", KerbalMapsWeb.RoomChannel
  channel "data:*", KerbalMapsWeb.DataChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket, _connect_info) do
    salt =
      Application.get_env(:kerbal_maps, KerbalMapsWeb.Endpoint)
      |> Keyword.get(:secret_key_base)

    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, salt, token, max_age: 1_209_600) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      {:error, _reason} ->
        :error
    end
  end

  # Unverified connects can only get the global channel.
  def connect(_params, socket, _connect_info) do
    {:ok, assign(socket, :user_id, 0)}
  end

  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
