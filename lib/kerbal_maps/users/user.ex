defmodule KerbalMaps.Users.User do
  @moduledoc """
  User schema.
  """

  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema, extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession]

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  ## this will get its own table/schema/etc.
  def markers(_user) do
    [
      %{latitude: 35.332031, longitude: -175.297852, label: "<strong>City</strong><br />Home"},
      %{latitude:  0.102329, longitude:  -74.568421, label: "<strong>Monolith</strong><br />KSC Monolith"},
      %{latitude:  2.490249, longitude: -141.395865, label: "<strong>Location</strong><br />The Great Desert"},
    ]
  end
end
