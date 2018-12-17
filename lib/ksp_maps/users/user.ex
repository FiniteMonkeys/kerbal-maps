defmodule KSPMaps.Users.User do
  @moduledoc """
  User schema.
  """

  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    timestamps()
  end
end
