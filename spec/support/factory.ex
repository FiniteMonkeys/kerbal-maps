defmodule KerbalMaps.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: KerbalMaps.Repo

  def celestial_body_factory do
    %KerbalMaps.StaticData.CelestialBody{
      name: Faker.Name.first_name(),
    }
  end

  def marker_factory do
    %KerbalMaps.Symbols.Marker{
      name: Faker.Name.first_name(),
      latitude: Faker.Address.latitude(),
      longitude: Faker.Address.longitude(),
      user_id: user_factory().id,
      celestial_body_id: celestial_body_factory().id,
      # altitude
      # description
      # icon_name
      # navigation_uuid
    }
  end

  def user_factory do
    %KerbalMaps.Users.User{
      email: Faker.Internet.email(),
    }
  end
end
