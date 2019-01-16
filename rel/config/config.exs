use Mix.Config

config :kerbal_maps, KerbalMaps.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 15

port = String.to_integer(System.get_env("PORT") || "8080")
config :kerbal_maps, KerbalMapsWeb.Endpoint,
  ## see https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#module-endpoint-configuration
  http: [port: port],
  url: [host: System.get_env("HOSTNAME"), port: port],
  root: ".",
  secret_key_base: System.get_env("SECRET_KEY_BASE")
