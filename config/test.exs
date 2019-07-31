use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kerbal_maps, KerbalMapsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :kerbal_maps, KerbalMaps.Repo,
  url: System.get_env("DATABASE_URL"),
  pool: Ecto.Adapters.SQL.Sandbox
