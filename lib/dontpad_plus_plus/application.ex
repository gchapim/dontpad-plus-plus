defmodule DontpadPlusPlus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias DontpadPlusPlus.PageTree

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DontpadPlusPlusWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DontpadPlusPlus.PubSub},
      # Start the Endpoint (http/https)
      DontpadPlusPlusWeb.Endpoint,
      {PageTree, name: {:global, PageTree}}
      # Start a worker by calling: DontpadPlusPlus.Worker.start_link(arg)
      # {DontpadPlusPlus.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DontpadPlusPlus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DontpadPlusPlusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
