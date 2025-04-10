defmodule CreepyCrawlieCinemaClub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CreepyCrawlieCinemaClubWeb.Telemetry,
      CreepyCrawlieCinemaClub.Repo,
      {DNSCluster, query: Application.get_env(:creepy_crawlie_cinema_club, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CreepyCrawlieCinemaClub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CreepyCrawlieCinemaClub.Finch},
      # Start a worker by calling: CreepyCrawlieCinemaClub.Worker.start_link(arg)
      # {CreepyCrawlieCinemaClub.Worker, arg},
      # Start to serve requests, typically the last entry
      CreepyCrawlieCinemaClubWeb.Endpoint,
      {Oban, Application.fetch_env!(:creepy_crawlie_cinema_club, Oban)},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CreepyCrawlieCinemaClub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CreepyCrawlieCinemaClubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
