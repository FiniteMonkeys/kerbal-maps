defmodule KerbalMapsWeb.PageController do
  @moduledoc """

  """

  use KerbalMapsWeb, :controller

  def index(conn, _params) do
    login_changeset = Pow.Plug.change_user(conn)

    render(conn, "index.html",
      login_changeset: login_changeset,
      login_action: Routes.pow_session_path(conn, :create)
    )
  end
end
