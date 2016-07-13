# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
           
config :passport,
  resource: PanelDemon.User,
  repo: PanelDemon.Repo

config :panel_demon, PanelDemon.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "xijLkenmYzD8zWOtkwfqNvFWzJqcIDnaqeB3Np6E2tIOGzfLXq3nnr0Hlr+1amjh",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: PanelDemon.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :panel_demon, :ecto_repos, [PanelDemon.Repo]



# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
