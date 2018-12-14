use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ksp_maps, KSPMapsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ksp_maps, KSPMaps.Repo,
  username: "postgres",
  password: "postgres",
  database: "ksp_maps_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
