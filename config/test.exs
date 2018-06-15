use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :valiot_app, ValiotAppWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :valiot_app, ValiotApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  # username: "postgres",
  # password: "postgres",
  database: "valiot_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :valiot_app, ValiotApp.ValiotRepo,
  adapter: Ecto.Adapters.Postgres,
  database: "valiot_server_test",
  # username: "postgres",
  # password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
