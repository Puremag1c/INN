# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :inn,
  ecto_repos: [Inn.Repo]

# Configures the endpoint
config :inn, InnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q/rCw+TtbKOgKc9KFY8SSsW5c6eb3t6+/IU/sFNNh1k2VFRQTIXOHkVAYaMxXJeN",
  render_errors: [view: InnWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Inn.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user, user:email, public_repo"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "2379373ead1840047cfa",
  client_secret: "479b5a876b063f936b7f64627fbc7c4b4980a378"
