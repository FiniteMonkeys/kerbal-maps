defmodule KerbalMaps.StaticData.PlanetPack do
  @moduledoc """
  PlanetPack schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  schema "planet_packs" do
    field :description, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(planet_pack, attrs) do
    planet_pack
    |> cast(attrs, [:description, :name, :url])
    |> validate_required([:name])
  end
end
