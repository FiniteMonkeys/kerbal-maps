defmodule KerbalMaps.StaticData.CelestialBody do
  @moduledoc """
  CelestialBody schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias KerbalMaps.StaticData.{CelestialBody, PlanetPack}

  schema "celestial_bodies" do
    field :name, :string
    field :biome_mapping, :map

    belongs_to :parent, CelestialBody
    has_many :moons, CelestialBody, foreign_key: :parent_id

    belongs_to :planet_pack, PlanetPack

    timestamps()
  end

  @doc false
  def changeset(celestial_body, attrs) do
    celestial_body
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_required([:planet_pack_id])
  end
end
