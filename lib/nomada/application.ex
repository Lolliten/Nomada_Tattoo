defmodule Nomada.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NomadaWeb.Telemetry,
      Nomada.Repo,
      {DNSCluster, query: Application.get_env(:nomada, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Nomada.PubSub},
      # Start a worker by calling: Nomada.Worker.start_link(arg)
      # {Nomada.Worker, arg},
      # Start to serve requests, typically the last entry
      NomadaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nomada.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NomadaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
