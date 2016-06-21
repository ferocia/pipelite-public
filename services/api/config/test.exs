use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pipelite, Pipelite.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, :console, level: :warn, format: "[$level] $message\n"

# Configure your database
config :pipelite, Pipelite.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  hostname: System.get_env("POSTGRES_1_PORT_5432_TCP_ADDR") || "postgres" || "localhost",
  port: System.get_env("POSTGRES_1_PORT_5432_TCP_PORT") || 5432,
  database: "pipelite_test",
  username: "postgres" || (elem(System.cmd("whoami", []), 0) |> String.strip(?\n)),
  pool_size: 1 # Use a single connection for transactional tests
