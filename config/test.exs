use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kerbal_maps, KerbalMapsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kerbal_maps, KerbalMaps.Repo,
  hostname: "127.0.0.1",
  port: "5432",
  username: "postgres",
  password: "",
  database: "kerbal_maps_test",
  pool: Ecto.Adapters.SQL.Sandbox
