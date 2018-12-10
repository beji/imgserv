defmodule ImgservWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  @cluster_topologies Application.get_env(:libcluster, :topologies)
  @env Mix.env()

  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    # List all child processes to be supervised
    children = children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ImgservWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children() do
    case @env do
      :test -> []
      _ ->
        [
          # Starts a worker by calling: ImgservWeb.Worker.start_link(arg)
          # {ImgservWeb.Worker, arg},
          # {Cluster.Supervisor, [@swarm_topologies, [name: Imgserv.ClusterSupervisor]]},
          {Cluster.Supervisor, [@cluster_topologies, [name: ImgservWeb.ClusterSupervisor]]},
          Plug.Adapters.Cowboy2.child_spec(
            scheme: :http,
            plug: ImgservWeb.Router,
            options: [port: 4000]
          ),
          ImgservWeb.Formatstore,
          ImgservWeb.Workerhandler,
          ImgservWeb.Cache
        ]
    end
  end

end
