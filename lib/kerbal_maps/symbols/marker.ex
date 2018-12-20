defmodule KerbalMaps.Symbols.Marker do
  @moduledoc """
  The Marker schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias KerbalMaps.StaticData.CelestialBody
  alias KerbalMaps.Users.User

  schema "markers" do
    field :altitude, :decimal
    field :description, :string
    field :icon_name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :navigation_uuid, Ecto.UUID

    belongs_to :owner, User, foreign_key: :user_id
    belongs_to :celestial_body, CelestialBody

    timestamps()
  end

  @doc false
  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [:name, :latitude, :longitude, :altitude, :navigation_uuid, :icon_name, :user_id, :celestial_body_id])
    |> validate_required([:name, :latitude, :longitude, :user_id, :celestial_body_id])
  end
end
