defmodule ImgservWorker.Worker do
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    {:ok, [], 0}
  end

  def handle_call({:convert, hash, format, imagedata}, _from, state) do
    data = ImgservWorker.ImageHandler.pipeline(hash, format, imagedata)
    {:reply, data, state}
  end

  @spec handle_cast({:exit, any()}, any()) :: {:stop, any(), any()}
  def handle_cast({:exit, reason}, state) do
    {:stop, reason, state}
  end

  @spec convert(pid(), String.t(), [key: String.t()] | [], binary()) :: binary()
  def convert(pid, hash, format, imagedata) do
    GenServer.call(pid, {:convert, hash, format, imagedata})
  end

  @spec exit(pid(), atom()) :: :ok
  def exit(pid, reason \\ :normal) do
    GenServer.cast(pid, {:exit, reason})
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :temporary,
      shutdown: 500
    }
  end
end
