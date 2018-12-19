defmodule KerbalMaps.Symbols.Marker do
  @moduledoc """
  The Marker schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "markers" do
    field :altitude, :decimal
    field :celestial_body_id, :id
    field :description, :string
    field :icon_name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :navigation_uuid, Ecto.UUID
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [:name, :latitude, :longitude, :altitude, :navigation_uuid, :icon_name, :user_id, :celestial_body_id])
    |> validate_required([:name, :latitude, :longitude, :user_id, :celestial_body_id])
  end
end
