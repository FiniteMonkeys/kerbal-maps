defmodule KerbalMaps.StaticData.Spec do
  @moduledoc false

  use ESpec

  require Logger

  import KerbalMaps.Factory

  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData
  # alias KerbalMaps.StaticData.CelestialBody

  # doctest KerbalMaps.StaticData

  example_group "celestial_bodies" do
    describe "list_celestial_bodies/1" do
      before do: allow Repo |> to(accept(:all, fn(_) -> static_list() end))
      let :static_list, do: [build(:celestial_body)]
      let :all_celestial_bodies, do: StaticData.list_celestial_bodies()

      it do: expect (all_celestial_bodies()) |> to(have_count(Enum.count(static_list())))
      it do: expect (all_celestial_bodies()) |> to(match_list(static_list()))
    end

    # before do
    #   {:shared,
    #     valid_attrs: %{name: "some name"},
    #     update_attrs: %{name: "some updated name"},
    #     invalid_attrs: %{name: nil}
    #   }
    # end

    # let :celestial_body_fixture do
    #   {:ok, celestial_body} =
    #     attrs
    #     |> Enum.into(shared.valid_attrs)
    #     |> StaticData.create_celestial_body()
    #
    #   celestial_body
    # end

    # describe "list_celestial_bodies/0" do
    #   let :celestial_body, do: celestial_body_fixture()
    #   it do
    #     expect (StaticData.list_celestial_bodies()) |> to(match_array([celestial_body()]))
    #   end
    # end

    # test "list_celestial_bodies/0 returns all celestial_bodies" do
    #   celestial_body = celestial_body_fixture()
    #   assert StaticData.list_celestial_bodies() == [celestial_body]
    # end

    # test "get_celestial_body!/1 returns the celestial_body with given id" do
    #   celestial_body = celestial_body_fixture()
    #   assert StaticData.get_celestial_body!(celestial_body.id) == celestial_body
    # end

    # test "create_celestial_body/1 with valid data creates a celestial_body" do
    #   assert {:ok, %CelestialBody{} = celestial_body} = StaticData.create_celestial_body(@valid_attrs)
    #   assert celestial_body.name == "some name"
    # end

    # test "create_celestial_body/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = StaticData.create_celestial_body(@invalid_attrs)
    # end

    # test "update_celestial_body/2 with valid data updates the celestial_body" do
    #   celestial_body = celestial_body_fixture()
    #   assert {:ok, %CelestialBody{} = celestial_body} = StaticData.update_celestial_body(celestial_body, @update_attrs)
    #   assert celestial_body.name == "some updated name"
    # end

    # test "update_celestial_body/2 with invalid data returns error changeset" do
    #   celestial_body = celestial_body_fixture()
    #   assert {:error, %Ecto.Changeset{}} = StaticData.update_celestial_body(celestial_body, @invalid_attrs)
    #   assert celestial_body == StaticData.get_celestial_body!(celestial_body.id)
    # end

    # test "delete_celestial_body/1 deletes the celestial_body" do
    #   celestial_body = celestial_body_fixture()
    #   assert {:ok, %CelestialBody{}} = StaticData.delete_celestial_body(celestial_body)
    #   assert_raise Ecto.NoResultsError, fn -> StaticData.get_celestial_body!(celestial_body.id) end
    # end

    # test "change_celestial_body/1 returns a celestial_body changeset" do
    #   celestial_body = celestial_body_fixture()
    #   assert %Ecto.Changeset{} = StaticData.change_celestial_body(celestial_body)
    # end
  end
end
