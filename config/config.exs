# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gatekeeper,
  ecto_repos: [Gatekeeper.Repo]

# Configures the endpoint
config :gatekeeper, GatekeeperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mujHtlIBki3zIkLqqGGycreaczy8M0UAV7MZEB14sDd/chFh5MF1uQKLxlBRjYaC",
  render_errors: [view: GatekeeperWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gatekeeper.PubSub, adapter: Phoenix.PubSub.PG2]

config :ueberauth, Ueberauth,
  providers: [
    keycloak: {Ueberauth.Strategy.Keycloak, [default_scope: "email username"]}
  ]

config :ueberauth, Ueberauth.Strategy.Keycloak.OAuth,
  client_id: "gatekeeper",
  client_secret: "89566914-6325-4c4d-9e80-fe786cac9110",
  redirect_uri: "http://localhost:4000/auth/keycloak"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
