use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :valiot_app, ValiotAppWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :valiot_app, :token_helper, %{
  url: "http://localauth",
  header: %{
    authorization: "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9..."
  }
}

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :valiot_app, ValiotApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  # username: "postgres",
  # password: "postgres",
  database: "valiot_app_dev",
  hostname: "localhost",
  pool_size: 10
