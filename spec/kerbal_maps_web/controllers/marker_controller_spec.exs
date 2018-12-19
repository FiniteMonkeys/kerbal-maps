defmodule KerbalMapsWeb.MarkerController.Spec do
  @moduledoc false

  use ESpec.Phoenix, controller: KerbalMapsWeb.MarkerController

  import KerbalMaps.Factory

  alias KerbalMapsWeb.Router.Helpers, as: Routes

  doctest KerbalMapsWeb.MarkerController

  example_group ":index" do
    let :conn, do: build_conn()
    let :request, do: conn() |> get(Routes.marker_path(conn(), :index))

    context "when not authenticated" do
      it "returns a redirect to the authentication page" do
        expect(html_response(request(), 302)) |> to(match("redirected"))
      end
    end

    context "when authenticated" do
      before do: allow Pow.Plug |> to(accept(:current_user, fn _ -> current_user() end))
      let :current_user, do: build(:user)

      it "returns all markers" do
        expect(html_response(request(), 200)) |> to(match("Listing Markers"))
      end
    end
  end


  # describe "new marker" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.marker_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Marker"
  #   end
  # end
  #
  # describe "create marker" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.marker_path(conn, :create), marker: @create_attrs)
  #
  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.marker_path(conn, :show, id)
  #
  #     conn = get(conn, Routes.marker_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Marker"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.marker_path(conn, :create), marker: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Marker"
  #   end
  # end
  #
  # describe "edit marker" do
  #   setup [:create_marker]
  #
  #   test "renders form for editing chosen marker", %{conn: conn, marker: marker} do
  #     conn = get(conn, Routes.marker_path(conn, :edit, marker))
  #     assert html_response(conn, 200) =~ "Edit Marker"
  #   end
  # end
  #
  # describe "update marker" do
  #   setup [:create_marker]
  #
  #   test "redirects when data is valid", %{conn: conn, marker: marker} do
  #     conn = put(conn, Routes.marker_path(conn, :update, marker), marker: @update_attrs)
  #     assert redirected_to(conn) == Routes.marker_path(conn, :show, marker)
  #
  #     conn = get(conn, Routes.marker_path(conn, :show, marker))
  #     assert html_response(conn, 200) =~ "some updated icon_name"
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, marker: marker} do
  #     conn = put(conn, Routes.marker_path(conn, :update, marker), marker: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Marker"
  #   end
  # end
  #
  # describe "delete marker" do
  #   setup [:create_marker]
  #
  #   test "deletes chosen marker", %{conn: conn, marker: marker} do
  #     conn = delete(conn, Routes.marker_path(conn, :delete, marker))
  #     assert redirected_to(conn) == Routes.marker_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.marker_path(conn, :show, marker))
  #     end
  #   end
  # end
  #
  # defp create_marker(_) do
  #   marker = fixture(:marker)
  #   {:ok, marker: marker}
  # end
end
