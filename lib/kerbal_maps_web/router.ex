defmodule KerbalMapsWeb.Router do
  @moduledoc false

  use KerbalMapsWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :kerbal_maps

  alias Phoenix.Token

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()

    get "/", KerbalMapsWeb.PageController, :index
  end

  scope "/", KerbalMapsWeb do
    pipe_through [:browser, :protected]

    resources "/markers", MarkerController, except: [:show]
    resources "/overlays", OverlayController, except: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", KerbalMapsWeb do
  #   pipe_through :api
  # end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      salt =
        Application.get_env(:kerbal_maps, KerbalMapsWeb.Endpoint)
        |> Keyword.get(:secret_key_base)

      token = Token.sign(conn, salt, current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
