defmodule KSPMaps.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ksp_maps,
    adapter: Ecto.Adapters.Postgres
end
