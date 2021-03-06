use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# ValiotAppWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :valiot_app, ValiotAppWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: System.get_env("DOMAIN"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :valiot_app, ValiotApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("DB_HOSTNAME"),
  database: System.get_env("DB_DATABASE"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl_opts: [
    cacertfile: "priv/rds-combined-ca-bundle.pem"
  ],
  ssl: true

# Do not print debug messages in production

config :valiot_app, :token_helper, %{
  url: System.get_env("STITCH_URL"),
  header: %{authorization: System.get_env("STITCH_AUTHORIZATION")}
}

config :logger, level: :info
