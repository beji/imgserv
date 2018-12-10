defmodule ImgservWorker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  @cluster_topologies Application.get_env(:libcluster, :topologies)

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ImgservWorker.Worker.start_link(arg)
      # {ImgservWorker.Worker, arg},
      {Cluster.Supervisor, [@cluster_topologies, [name: ImgservWorker.ClusterSupervisor]]},
      {DynamicSupervisor, strategy: :one_for_one, name: ImgservWorker.DynamicSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
