# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :creepy_crawlie_cinema_club,
  ecto_repos: [CreepyCrawlieCinemaClub.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :creepy_crawlie_cinema_club, CreepyCrawlieCinemaClubWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [
      html: CreepyCrawlieCinemaClubWeb.ErrorHTML,
      json: CreepyCrawlieCinemaClubWeb.ErrorJSON
    ],
    layout: false
  ],
  pubsub_server: CreepyCrawlieCinemaClub.PubSub,
  live_view: [signing_salt: "cqHBL0T6"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
# Configure Swoosh with your SMTP settings or another adapter.
config :creepy_crawlie_cinema_club, CreepyCrawlieCinemaClub.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.gmail.com",
  port: 587,
  ssl: false,
  tls: :always,
  auth: :always,
  username: System.get_env("GMAIL_USERNAME"),
  password: System.get_env("GMAIL_APP_PASSWORD")

# Configure the weekly email recipients.
config :creepy_crawlie_cinema_club, :weekly_email_recipients,
  [
    "joe.fogiato@gmail.com",
    "armandalore@gmail.com",
    "cszerenyi@gmail.com",
    "azarate32@gmail.com",
    "luisgportillo8191@gmail.com"
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  creepy_crawlie_cinema_club: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  creepy_crawlie_cinema_club: [
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

# Configure Oban
config :creepy_crawlie_cinema_club, Oban,
repo: CreepyCrawlieCinemaClub.Repo,
queues: [default: 10],
plugins: [
  {Oban.Plugins.Cron,
    crontab: [
       # "0 21 * * 5" fires every Friday at 21:00 UTC (i.e. 9pm UTC/5pm EST)
       {"0 21 * * 5", CreepyCrawlieCinemaClub.Jobs.WeeklyEmail}
    ]}
]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
