defmodule KerbalMapsWeb.PageController do
  @moduledoc """

  """

  use KerbalMapsWeb, :controller

  require Logger

  alias Pow.Plug

  def index(conn, params) do
    login_changeset = Plug.change_user(conn)

    render(conn, "index.html",
      login_changeset: login_changeset,
      login_action: Routes.pow_session_path(conn, :create),
      body_from_query: get_body_from_params(params),
      loc_from_query: get_loc_from_params(params)
    )
  end

  def current_app_version do
    :application.which_applications()
    |> Enum.find(fn t -> elem(t, 0) == :kerbal_maps end)
    |> elem(2)
  end

  # %{"body" => "Kerbin", "loc" => "12.34,-56.78"}
  def get_body_from_params(%{"body" => value}), do: value |> String.downcase
  def get_body_from_params(_), do: nil

  def get_loc_from_params(%{"loc" => value}) do
    KerbalMaps.CoordinateParser.parse(value)
    |> Enum.join(",")
  end
  def get_loc_from_params(_), do: nil
end
