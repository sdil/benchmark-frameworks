# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo_phoenix,
  ecto_repos: [TodoPhoenix.Repo]

# Configures the endpoint
config :todo_phoenix, TodoPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TAHPrqL+V4PE8Ftv8/lAdxku8/KkIRIPZ5K1IJfeuepaLsNOV6EpM/l7+zqrbTo1",
  render_errors: [view: TodoPhoenixWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TodoPhoenix.PubSub,
  live_view: [signing_salt: "J4RuIHD3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
