defmodule KerbalMaps.Users.Spec do
  @moduledoc false

  use ESpec

  require Logger

  import KerbalMaps.Factory

  alias KerbalMaps.Repo
  alias KerbalMaps.Users
  # alias KerbalMaps.Users.User

  # doctest KerbalMaps.Users

  example_group "users" do
    describe "list_users/1" do
      before do: allow Repo |> to(accept(:all, fn(_) -> static_list() end))
      let :static_list, do: [build(:user)]
      let :all_users, do: Users.list_users()

      it do: expect (all_users()) |> to(have_count(Enum.count(static_list())))
      it do: expect (all_users()) |> to(match_list(static_list()))
    end

    # before do
    #   {:shared,
    #     valid_attrs: %{name: "some name"},
    #     update_attrs: %{name: "some updated name"},
    #     invalid_attrs: %{name: nil}
    #   }
    # end

    # let :celestial_body_fixture do
    #   {:ok, user} =
    #     attrs
    #     |> Enum.into(shared.valid_attrs)
    #     |> Users.create_celestial_body()
    #
    #   user
    # end

    # describe "list_users/0" do
    #   let :user, do: celestial_body_fixture()
    #   it do
    #     expect (Users.list_users()) |> to(match_array([user()]))
    #   end
    # end

    # test "list_users/0 returns all users" do
    #   user = celestial_body_fixture()
    #   assert Users.list_users() == [user]
    # end

    # test "get_celestial_body!/1 returns the user with given id" do
    #   user = celestial_body_fixture()
    #   assert Users.get_celestial_body!(user.id) == user
    # end

    # test "create_celestial_body/1 with valid data creates a user" do
    #   assert {:ok, %CelestialBody{} = user} = Users.create_celestial_body(@valid_attrs)
    #   assert user.name == "some name"
    # end

    # test "create_celestial_body/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Users.create_celestial_body(@invalid_attrs)
    # end

    # test "update_celestial_body/2 with valid data updates the user" do
    #   user = celestial_body_fixture()
    #   assert {:ok, %CelestialBody{} = user} = Users.update_celestial_body(user, @update_attrs)
    #   assert user.name == "some updated name"
    # end

    # test "update_celestial_body/2 with invalid data returns error changeset" do
    #   user = celestial_body_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Users.update_celestial_body(user, @invalid_attrs)
    #   assert user == Users.get_celestial_body!(user.id)
    # end

    # test "delete_celestial_body/1 deletes the user" do
    #   user = celestial_body_fixture()
    #   assert {:ok, %CelestialBody{}} = Users.delete_celestial_body(user)
    #   assert_raise Ecto.NoResultsError, fn -> Users.get_celestial_body!(user.id) end
    # end

    # test "change_celestial_body/1 returns a user changeset" do
    #   user = celestial_body_fixture()
    #   assert %Ecto.Changeset{} = Users.change_celestial_body(user)
    # end
  end
end
