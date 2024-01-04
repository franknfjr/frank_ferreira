# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :frank_ferreira,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :frank_ferreira, FrankFerreiraWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: FrankFerreiraWeb.ErrorHTML, json: FrankFerreiraWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FrankFerreira.PubSub,
  live_view: [signing_salt: "m82xUv3o"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Specify which languages you support
# To create .po files for a language run `mix gettext.merge priv/gettext --locale pt-BR`
# (fr is France, change to whatever language you want - make sure it's included in the locales config below)
config :frank_ferreira, FrankFerreiraWeb.Gettext, allowed_locales: ~w(pt-br en es)

config :frank_ferreira, :language_options, [
  %{locale: "pt-br", flag: "🇧🇷", label: "Brasil"},
  %{locale: "en", flag: "🇬🇧", label: "English"},
  %{locale: "es", flag: "🇪🇸", label: "Spain"}
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
