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
  hostname: "127.0.0.1",
  port:     "5432",
  username: "postgres",
  password: "",
  database: "ksp_maps_test",
  pool: Ecto.Adapters.SQL.Sandbox
