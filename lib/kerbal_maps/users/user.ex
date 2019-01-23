defmodule KerbalMaps.Users.User do
  @moduledoc """
  The User schema.
  """

  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession]

  import Ecto.Changeset

  alias KerbalMaps.Symbols.Marker

  schema "users" do
    pow_user_fields()

    has_many :markers, Marker

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def changeset_with_user_id(user_or_changeset, attrs) do
    changeset(user_or_changeset, attrs)
    |> cast(attrs, [:id])
  end
end
