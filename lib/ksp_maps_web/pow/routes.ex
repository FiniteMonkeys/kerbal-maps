defmodule KSPMapsWeb.Pow.Routes do
  @moduledoc false

  use Pow.Phoenix.Routes

  alias KSPMapsWeb.Router.Helpers, as: Routes

  def after_sign_out_path(conn), do: Routes.page_path(conn, :index)
end
