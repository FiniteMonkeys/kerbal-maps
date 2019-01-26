defmodule KerbalMapsWeb.PageController do
  @moduledoc """

  """

  use KerbalMapsWeb, :controller

  alias Pow.Plug

  def index(conn, _params) do
    login_changeset = Plug.change_user(conn)

    render(conn, "index.html",
      login_changeset: login_changeset,
      login_action: Routes.pow_session_path(conn, :create)
    )
  end

  def current_app_version do
    :application.which_applications()
    |> Enum.find(fn t -> elem(t, 0) == :kerbal_maps end)
    |> elem(2)
  end
end
