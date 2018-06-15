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
  hostname: "disruptivedatabase.chyfrjxl7wh6.us-east-1.rds.amazonaws.com",
  database: "valiot_server_test",
  username: "valiot_server_test_user",
  password: "vUj8hbYA9Wdo",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl_opts: [
    cacertfile: "priv/rds-combined-ca-bundle.pem"
  ],
  ssl: true,
  pool: Ecto.Adapters.SQL.Sandbox
