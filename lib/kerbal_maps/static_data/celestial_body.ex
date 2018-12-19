defmodule KerbalMaps.StaticData.CelestialBody do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias KerbalMaps.StaticData.CelestialBody

  schema "celestial_bodies" do
    field :name, :string

    belongs_to :parent, CelestialBody
    has_many :moons, CelestialBody

    timestamps()
  end

  @doc false
  def changeset(celestial_body, attrs) do
    celestial_body
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
