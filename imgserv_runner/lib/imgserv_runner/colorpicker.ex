defmodule ImgservRunner.Colorpicker do
  use GenServer

  @colors Application.get_env(:imgserv_runner, :colors)

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  @spec init(any) :: {:ok, [String.t]}
  def init(_) do
    state =
      @colors
      |> Enum.map(&to_ansi/1)
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    [head | tail] = state
    {:reply, head, tail ++ [head]}
  end

  defp to_ansi(:cyan) do
    IO.ANSI.cyan()
  end

  defp to_ansi(:yellow) do
    IO.ANSI.yellow()
  end

  defp to_ansi(:magenta) do
    IO.ANSI.magenta()
  end

  defp to_ansi(:red) do
    IO.ANSI.red()
  end

  defp to_ansi(:green) do
    IO.ANSI.green()
  end

  defp to_ansi(:blue) do
    IO.ANSI.blue()
  end

  @spec get_color() :: String.t
  def get_color() do
    GenServer.call(__MODULE__, :get)
  end
end
