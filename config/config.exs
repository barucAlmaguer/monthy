# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :valiot_app, ecto_repos: [ValiotApp.Repo, ValiotApp.ValiotRepo]

# Configures the endpoint
config :valiot_app, ValiotAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oEk0v3Xp1c0XcmPsBiZ5z1s3bMk4FTDeUPEKbW68F8R9TBwYKIU4JTAcN1MB62yt",
  render_errors: [view: ValiotAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ValiotApp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :valiot_app, ValiotAppWeb.Guardian,
  issuer: "valiot_app",
  secret_key: "z5q2F7BkLWeNCDsZGbLeZ8WY98CHZlWqydbzrwHsu1vq/K0talZqvfoSQG7eFXxM"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
