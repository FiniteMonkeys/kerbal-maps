defmodule ESpec.Phoenix.Extend do
  @moduledoc false

  def model do
    quote do
      alias KerbalMaps.Repo
    end
  end

  def controller do
    quote do
      alias KerbalMaps
      # import KerbalMaps.Router.Helpers

      @endpoint KerbalMapsWeb.Endpoint
    end
  end

  def view do
    quote do
      # import KerbalMaps.Router.Helpers
    end
  end

  def channel do
    quote do
      alias KerbalMaps.Repo

      @endpoint KerbalMapsWeb.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
