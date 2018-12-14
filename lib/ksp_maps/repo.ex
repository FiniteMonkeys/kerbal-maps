defmodule KSPMaps.Repo do
  use Ecto.Repo,
    otp_app: :ksp_maps,
    adapter: Ecto.Adapters.Postgres
end
