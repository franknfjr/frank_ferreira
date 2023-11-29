defmodule FrankFerreira.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FrankFerreiraWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:frank_ferreira, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FrankFerreira.PubSub},
      # Start a worker by calling: FrankFerreira.Worker.start_link(arg)
      # {FrankFerreira.Worker, arg},
      # Start to serve requests, typically the last entry
      FrankFerreiraWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FrankFerreira.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FrankFerreiraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
