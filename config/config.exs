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
  client_secret: "505055a7-4aa3-450d-b8fa-76f668fc354b",
  redirect_uri: "http://localhost:4000/auth/keycloak"

config :gatekeeper, Gatekeeper.Guardian,
  issuer: "gatekeeper",
  secret_key: "XGeQLQiAf768aKp2RIugOl/Yty0T5pfi3qL03LCeqKWQ2v5bwOFtbjdpfSbVPEuM"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
