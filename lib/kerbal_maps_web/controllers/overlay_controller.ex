defmodule KerbalMapsWeb.OverlayController do
  use KerbalMapsWeb, :controller

  alias KerbalMaps.Symbols
  alias KerbalMaps.Symbols.Overlay

  def index(conn, _params) do
    overlays = Symbols.list_overlays()
    render(conn, "index.html", overlays: overlays)
  end

  def new(conn, _params) do
    changeset = Symbols.change_overlay(%Overlay{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"overlay" => overlay_params}) do
    case Symbols.create_overlay(overlay_params) do
      {:ok, overlay} ->
        conn
        |> put_flash(:info, "Overlay created successfully.")
        |> redirect(to: Routes.overlay_path(conn, :show, overlay))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    overlay = Symbols.get_overlay!(id)
    render(conn, "show.html", overlay: overlay)
  end

  def edit(conn, %{"id" => id}) do
    overlay = Symbols.get_overlay!(id)
    changeset = Symbols.change_overlay(overlay)
    render(conn, "edit.html", overlay: overlay, changeset: changeset)
  end

  def update(conn, %{"id" => id, "overlay" => overlay_params}) do
    overlay = Symbols.get_overlay!(id)

    case Symbols.update_overlay(overlay, overlay_params) do
      {:ok, overlay} ->
        conn
        |> put_flash(:info, "Overlay updated successfully.")
        |> redirect(to: Routes.overlay_path(conn, :show, overlay))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", overlay: overlay, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    overlay = Symbols.get_overlay!(id)
    {:ok, _overlay} = Symbols.delete_overlay(overlay)

    conn
    |> put_flash(:info, "Overlay deleted successfully.")
    |> redirect(to: Routes.overlay_path(conn, :index))
  end
end
