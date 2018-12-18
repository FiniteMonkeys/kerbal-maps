defmodule KerbalMapsWeb.PageController do
  use KerbalMapsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
