defmodule KerbalMaps.Symbols.Overlay do
  @moduledoc """
  The Overlay schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  # import ESpec.Testable

  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData.CelestialBody
  alias KerbalMaps.Symbols
  alias KerbalMaps.Symbols.Marker
  alias KerbalMaps.Symbols.Overlay
  alias KerbalMaps.Users.User

  schema "overlays" do
    field :name, :string
    field :description, :string

    belongs_to :owner, User, foreign_key: :user_id
    belongs_to :celestial_body, CelestialBody
    many_to_many :markers, Marker, join_through: "overlays_markers"

    timestamps()
  end

  @doc false
  def changeset(overlay, attrs) do
    overlay
    |> cast(attrs, [:name, :description, :user_id, :celestial_body_id])
    |> validate_required([:name, :user_id, :celestial_body_id])
  end

  def insert_overlay(params) do
    Repo.insert!(%Overlay{
      name: Keyword.fetch!(params, :name),
      description: Keyword.get(params, :description),
      user_id: Keyword.fetch!(params, :user).id,
      celestial_body_id: Keyword.fetch!(params, :body).id,
    } |> Overlay.changeset(%{}) |> Ecto.Changeset.apply_changes())
  end

  def add_marker(overlay, marker_name) do
    marker = Symbols.find_marker_by_name(marker_name, %{"user_id" => overlay.user_id, "celestial_body_id" => overlay.celestial_body_id})
    Repo.query!(
      "INSERT INTO overlays_markers (overlay_id, marker_id, user_id, celestial_body_id, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6)",
      [overlay.id, marker.id, overlay.user_id, overlay.celestial_body_id, DateTime.utc_now(), DateTime.utc_now()]
    )
    overlay
  end
end
