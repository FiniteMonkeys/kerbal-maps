# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kerbal_maps,
  namespace: KerbalMaps,
  ecto_repos: [KerbalMaps.Repo]

# Configures the endpoint
config :kerbal_maps, KerbalMapsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x12IOaIt5hO6FI2MfjUzthOK/RrD77R/loxo4f4cEGKAaWmbbudcGjv/zzgoTk+I",
  render_errors: [view: KerbalMapsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KerbalMaps.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Pow for user authentication and management
config :kerbal_maps, :pow,
  repo: KerbalMaps.Repo,
  user: KerbalMaps.Users.User,
  routes_backend: KerbalMapsWeb.Pow.Routes,
  web_module: KerbalMapsWeb,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: KerbalMapsWeb.PowMailer

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
