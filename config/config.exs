# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ksp_maps,
  namespace: KSPMaps,
  ecto_repos: [KSPMaps.Repo]

# Configures the endpoint
config :ksp_maps, KSPMapsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x12IOaIt5hO6FI2MfjUzthOK/RrD77R/loxo4f4cEGKAaWmbbudcGjv/zzgoTk+I",
  render_errors: [view: KSPMapsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KSPMaps.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Pow for user authentication and management
config :ksp_maps, :pow,
  repo: KSPMaps.Repo,
  user: KSPMaps.Users.User,
  routes_backend: KSPMapsWeb.Pow.Routes,
  web_module: KSPMapsWeb,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
