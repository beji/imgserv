defmodule ImgservDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @db_modules [ImgservDb.Table.Format]
  @cluster_topologies Application.get_env(:libcluster, :topologies)

  def start(_type, _args) do
    init_db()
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ImgservDb.Worker.start_link(arg)
      # {ImgservDb.Worker, arg},
      {Cluster.Supervisor, [@cluster_topologies, [name: ImgservDb.ClusterSupervisor]]},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ImgservDb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp init_db() do
    nodes = [ node() ]

    if path = Application.get_env(:mnesia, :dir) do
      :ok = File.mkdir_p!(path)
    end

    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start

    @db_modules
    |> Enum.each(fn module ->
      case Memento.Table.create(module, disc_copies: nodes) do
        :ok ->
          Logger.info(fn -> "Set up table for #{module}" end)
          preseed(module)
        {:error, {:already_exists, _}} -> Logger.info(fn -> "Table #{module} already exists" end)
      end
    end)
  end

  defp preseed(ImgservDb.Table.Format) do

    formats = [{"test", [resize_limit: "800x200", background: "#000000"]},
    {"thumbnail", [resize_limit: "200x200"]},
    {"original", []}]
    ImgservDb.Table.Format.create(formats)
  end

  defp preseed(_module) do
    :ok
  end
end
