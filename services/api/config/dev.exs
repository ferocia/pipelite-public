use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :pipelite, Pipelite.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  reloadable_paths: ["web", "lib"],
  cache_static_lookup: false,
  watchers: [],
  check_origin: ["//127.0.0.1", "//localhost", "//docker.local"]

# Watch static and templates for browser reloading.
config :pipelite, Pipelite.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :pipelite, Pipelite.Repo,
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Pipelite.JSONExtension, [library: Poison]}],
  hostname: "postgres",
  username: "postgres",
  port: 5432,
  database: "pipelite_dev",
  pool_size: 10 # The amount of database connections in the pool
