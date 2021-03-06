# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :dontpad_plus_plus, DontpadPlusPlusWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "g9HznEdj9omjxDSBiDxgOdQK0oUW/I6CiamcV0z1M2s4mS2HOiWoplgPz+WPszOK",
  render_errors: [view: DontpadPlusPlusWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DontpadPlusPlus.PubSub,
  live_view: [signing_salt: "3oFUjenR"]

config :dontpad_plus_plus, :textarea_reload_time, 20_000

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
