defmodule KerbalMaps.Symbols.Overlay do
  @moduledoc """
  The Overlay schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  # import ESpec.Testable

  alias KerbalMaps.Users.User

  schema "overlays" do
    field :name, :string

    belongs_to :owner, User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(overlay, attrs) do
    overlay
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
