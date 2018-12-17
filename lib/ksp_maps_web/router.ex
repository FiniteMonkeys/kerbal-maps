defmodule KSPMapsWeb.Router do
  @moduledoc false

  use KSPMapsWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()

    get "/", KSPMapsWeb.PageController, :index
  end

  scope "/", KSPMapsWeb do
    pipe_through [:browser, :protected]

  end

  # Other scopes may use custom stacks.
  # scope "/api", KSPMapsWeb do
  #   pipe_through :api
  # end
end
