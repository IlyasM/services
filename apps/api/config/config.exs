# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: Api,
  ecto_repos: [Api.Repo]

config :api, Api.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SENDGRID")

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4TFwuiLiJ/9EKlMe7y++k4hNg9+VQUvpCOLuHTHXRNV7EKUL7K0rIyMsIFoisdsq",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Api.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
