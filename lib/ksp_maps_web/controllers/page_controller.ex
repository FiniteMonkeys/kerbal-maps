defmodule KSPMapsWeb.PageController do
  use KSPMapsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
