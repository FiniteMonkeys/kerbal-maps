use Mix.Config

config :kerbal_maps, KerbalMapsWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :kerbal_maps, KerbalMapsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/kerbal_maps_web/views/.*(ex)$},
      ~r{lib/kerbal_maps_web/templates/.*(eex)$}
    ]
  ]

config :kerbal_maps, KerbalMaps.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
