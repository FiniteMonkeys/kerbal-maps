defmodule KerbalMapsWeb.PageController do
  @moduledoc """

  """

  use KerbalMapsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
