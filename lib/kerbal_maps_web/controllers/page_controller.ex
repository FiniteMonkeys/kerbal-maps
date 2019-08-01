defmodule KerbalMapsWeb.PageController do
  @moduledoc """

  """

  use KerbalMapsWeb, :controller

  require Logger

  alias KerbalMaps.CoordinateParser
  alias Pow.Plug

  def index(conn, params) do
    login_changeset = Plug.change_user(conn)

    render(conn, "index.html",
      login_changeset: login_changeset,
      login_action: Routes.pow_session_path(conn, :create),
      body_from_query: get_body_from_params(params),
      label_from_query: get_label_from_params(params),
      loc_from_query: get_loc_from_params(params),
      zoom_from_query: get_zoom_from_params(params)
    )
  end

  def current_app_version do
    # :application.which_applications()
    # |> Enum.find(fn t -> elem(t, 0) == :kerbal_maps end)
    # |> elem(2)
    "0.3.6"
  end

  # %{"body" => "Kerbin", "loc" => "12.34,-56.78"}
  def get_body_from_params(%{"body" => value}), do: value |> String.downcase()
  def get_body_from_params(_), do: nil

  def get_label_from_params(%{"loc" => value}), do: CoordinateParser.parse_marker_label(value)
  def get_label_from_params(_), do: nil

  def get_loc_from_params(%{"center" => value}), do: CoordinateParser.parse_coordinate(value) |> Enum.join(",")
  def get_loc_from_params(%{"loc" => value}), do: CoordinateParser.parse_coordinate(value) |> Enum.join(",")
  def get_loc_from_params(_), do: nil

  def get_zoom_from_params(%{"zoom" => value}), do: value
  def get_zoom_from_params(_), do: nil
end
