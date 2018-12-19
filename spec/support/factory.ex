defmodule KerbalMaps.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: KerbalMaps.Repo

  def celestial_body_factory do
    %KerbalMaps.StaticData.CelestialBody{
      name: Faker.Name.first_name(),
    }
  end

  def user_factory do
    %KerbalMaps.Users.User{
      email: Faker.Internet.email(),
    }
  end
end
