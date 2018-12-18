defmodule KSPMapsWeb.Pow.Routes do
  @moduledoc false

  use Pow.Phoenix.Routes

  alias KSPMapsWeb.Router.Helpers, as: Routes

  # def user_not_authenticated_path(conn), do: nil
  # def user_already_authenticated_path(conn), do: nil
  def after_sign_out_path(conn), do: Routes.page_path(conn, :index)
  def after_sign_in_path(conn), do: Routes.page_path(conn, :index)
  # def after_registration_path(conn), do: nil
  # def after_user_updated_path(conn), do: nil
  # def after_user_deleted_path(conn), do: nil
  # session_path(conn, atom(), list())
  # registration_path(conn, atom())
  # path_for(conn, atom(), atom(), list(), Keyword.t())
  # url_for(conn, atom(), atom(), list(), Keyword.t())
end
