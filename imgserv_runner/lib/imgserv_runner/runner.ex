defmodule ImgservRunner.Runner do
  use GenServer

  @wrapper Application.app_dir(:imgserv_runner, "priv/wrapper.sh")
  @separator Application.get_env(:imgserv_runner, :separator)

  @type t :: %__MODULE__{id: String.t, worker_id: atom, use_wrapper: boolean, command: String.t, args: [String.t]}
  defstruct [:id, :worker_id, :use_wrapper, :command, :args]

  @spec start_link(map) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(config) do
    configstate = struct(__MODULE__, Enum.to_list(config))
    GenServer.start_link(__MODULE__, configstate)
  end

  @impl true
  @spec init(t) :: {:ok, {binary(), port(), any()}}
  def init(config) do
    Process.flag(:trap_exit, true)

    {executable, args} = if config.use_wrapper do
      {@wrapper, [config.command | config.args]}
    else
      {config.command, config.args}
    end

    port = Port.open({:spawn_executable, executable}, [{:args, args}, :stream, :binary, :exit_status, :hide, :use_stdio, :stderr_to_stdout])
    {:os_pid, pid} = Port.info(port, :os_pid)
    {:ok, {colorize_process(config.id), port, pid}}
  end

  @impl true
  def handle_info({_port, {:data, msg}}, {process, _, _} = state) do

    unless filter?(msg) do
      colored_msg =
        msg
        |> String.trim()
        |> add_color()
      IO.puts([process, @separator, colored_msg])
    end

    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, {_name, _port, pid}) do
    System.cmd("kill", ["-#{pid}"])
    :ok
  end

  @spec filter?(String.t) :: boolean
  defp filter?(msg) when is_bitstring(msg) do
    cond do
      String.starts_with?(msg, "iex(") -> true
      String.starts_with?(msg, "Interactive Elixir (") -> true
      true -> false
    end
  end

  @spec add_color(String.t) :: String.t
  defp add_color(msg) when is_bitstring(msg) do
    color = cond do
      String.contains?(msg, "[debug]") -> IO.ANSI.cyan()
      String.contains?(msg, "[warn]") -> IO.ANSI.yellow()
      String.contains?(msg, "[error]") -> IO.ANSI.red()
      true -> ""
    end
    "#{color}#{msg}#{IO.ANSI.reset()}"
  end

  @spec colorize_process(String.t) :: String.t
  defp colorize_process(process) when is_bitstring(process) do
    "#{ImgservRunner.Colorpicker.get_color()}#{process}#{IO.ANSI.reset()}"
  end

end
