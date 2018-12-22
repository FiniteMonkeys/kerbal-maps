defmodule KerbalMapsWeb.OverlayControllerTest do
  @moduledoc false

  use ESpec.Phoenix, controller: KerbalMapsWeb.OverlayController

  import KerbalMaps.Factory

  alias KerbalMapsWeb.Router.Helpers, as: Routes

  doctest KerbalMapsWeb.OverlayController

  example_group ":index" do
    let :request, do: conn() |> get(Routes.overlay_path(conn(), :index))
    let :unauthenticated_conn, do: build_conn()
    let :authenticated_conn, do: build_conn() |> Plug.Conn.assign(:current_user, current_user())

    context "when not authenticated" do
      let :conn, do: unauthenticated_conn()
      it "returns a redirect to the authentication page" do
        expect(html_response(request(), 302)) |> to(match("redirected"))
      end
    end

    context "when authenticated" do
      let :conn, do: authenticated_conn()
      let :current_user, do: build(:user)

      it "returns all markers" do
        expect(html_response(request(), 200)) |> to(match("Listing Overlays"))
      end
    end
  end


  # describe "new overlay" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.overlay_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Overlay"
  #   end
  # end
  #
  # describe "create overlay" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.overlay_path(conn, :create), overlay: @create_attrs)
  #
  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.overlay_path(conn, :show, id)
  #
  #     conn = get(conn, Routes.overlay_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Overlay"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.overlay_path(conn, :create), overlay: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Overlay"
  #   end
  # end
  #
  # describe "edit overlay" do
  #   setup [:create_overlay]
  #
  #   test "renders form for editing chosen overlay", %{conn: conn, overlay: overlay} do
  #     conn = get(conn, Routes.overlay_path(conn, :edit, overlay))
  #     assert html_response(conn, 200) =~ "Edit Overlay"
  #   end
  # end
  #
  # describe "update overlay" do
  #   setup [:create_overlay]
  #
  #   test "redirects when data is valid", %{conn: conn, overlay: overlay} do
  #     conn = put(conn, Routes.overlay_path(conn, :update, overlay), overlay: @update_attrs)
  #     assert redirected_to(conn) == Routes.overlay_path(conn, :show, overlay)
  #
  #     conn = get(conn, Routes.overlay_path(conn, :show, overlay))
  #     assert html_response(conn, 200) =~ "some updated name"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, overlay: overlay} do
  #     conn = put(conn, Routes.overlay_path(conn, :update, overlay), overlay: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Overlay"
  #   end
  # end
  #
  # describe "delete overlay" do
  #   setup [:create_overlay]
  #
  #   test "deletes chosen overlay", %{conn: conn, overlay: overlay} do
  #     conn = delete(conn, Routes.overlay_path(conn, :delete, overlay))
  #     assert redirected_to(conn) == Routes.overlay_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.overlay_path(conn, :show, overlay))
  #     end
  #   end
  # end
  #
  # defp create_overlay(_) do
  #   overlay = fixture(:overlay)
  #   {:ok, overlay: overlay}
  # end
end
