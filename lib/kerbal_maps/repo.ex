defmodule KerbalMaps.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :kerbal_maps,
    adapter: Ecto.Adapters.Postgres
end
