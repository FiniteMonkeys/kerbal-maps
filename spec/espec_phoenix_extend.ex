defmodule ESpec.Phoenix.Extend do
  @moduledoc false

  def model do
    quote do
      alias KSPMaps.Repo
    end
  end

  def controller do
    quote do
      alias KSPMaps
      # import KSPMaps.Router.Helpers

      @endpoint KSPMapsWeb.Endpoint
    end
  end

  def view do
    quote do
      # import KSPMaps.Router.Helpers
    end
  end

  def channel do
    quote do
      alias KSPMaps.Repo

      @endpoint KSPMapsWeb.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
