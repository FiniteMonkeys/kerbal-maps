defmodule KerbalMaps.Symbols.Overlay do
  @moduledoc """
  The Overlay schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  # import ESpec.Testable

  alias KerbalMaps.StaticData.CelestialBody
  alias KerbalMaps.Users.User

  schema "overlays" do
    field :name, :string
    field :description, :string

    belongs_to :owner, User, foreign_key: :user_id
    belongs_to :celestial_body, CelestialBody

    timestamps()
  end

  @doc false
  def changeset(overlay, attrs) do
    overlay
    |> cast(attrs, [:name, :description, :user_id, :celestial_body_id])
    |> validate_required([:name, :user_id, :celestial_body_id])
  end
end
