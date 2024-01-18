defmodule Unity.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UnityWeb.Telemetry,
      Unity.Repo,
      {DNSCluster, query: Application.get_env(:unity, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Unity.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Unity.Finch},
      # Start a worker by calling: Unity.Worker.start_link(arg)
      # {Unity.Worker, arg},
      # Start to serve requests, typically the last entry
      UnityWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Unity.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UnityWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
