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

config :valiot_app, :token_helper, %{
  url: "https://test.valiot.app/",
  header: %{
    authorization:
      "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTQyMjMzNTc2LCJpYXQiOjE1Mzk4MTQzNzYsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiI5ZTUyZDI1MC1kZTU3LTQ0ZTQtOTMwZi03NjYyOGFkOWYzYjYiLCJuYmYiOjE1Mzk4MTQzNzUsInN1YiI6IiIsInR5cCI6ImFjY2VzcyJ9.CFFFFUsfmWBHX_B0GLlq9BASg91UkXcPPUCVXdXbX9nB9LzwfeH1Pejs7NX0gSCRkC8DR-1j3BL__8bGhjZkiw"
  }
}
