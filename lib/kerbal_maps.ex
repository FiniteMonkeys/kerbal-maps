defmodule KerbalMaps do
  @moduledoc """
  KerbalMaps keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query

  alias KerbalMaps.Repo
  alias KerbalMaps.Users.User

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  def find_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one
  end
end
