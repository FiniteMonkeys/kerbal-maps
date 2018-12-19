defmodule KerbalMaps.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: KerbalMaps.Repo

  def celestial_body_factory do
    %KerbalMaps.StaticData.CelestialBody{
      name: Faker.Name.first_name(),
    }
  end
end
