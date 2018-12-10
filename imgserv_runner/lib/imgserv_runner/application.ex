defmodule ImgservRunner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @children Application.get_env(:imgserv_runner, :worker_config)
  |> Enum.filter(fn config -> Map.get(config, :enabled, true) end)
  |> Enum.map(fn config ->
    Supervisor.child_spec({ImgservRunner.Runner, config}, id: config.worker_id)
  end)

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ImgservRunner.Worker.start_link(arg)
      # {ImgservRunner.Worker, arg},
      ImgservRunner.Colorpicker
    ] ++ @children

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ImgservRunner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_) do
    IO.inspect("#{__MODULE__}.stop")
  end
end
