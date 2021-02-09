use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dontpad_plus_plus, DontpadPlusPlusWeb.Endpoint,
  http: [port: 4002],
  server: false

config :dontpad_plus_plus, :textarea_reload_time, 100

# Print only warnings and errors during test
config :logger, level: :warn
