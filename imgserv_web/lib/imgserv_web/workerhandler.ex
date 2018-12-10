defmodule ImgservWeb.Workerhandler do
  use GenServer

  require Logger

  @loop_time 5000

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    GenServer.cast(self(), :loop)
    {:ok, get_worker_nodes()}
  end

  @impl true
  def handle_cast(:loop, state) do
    Logger.debug("#{__MODULE__} running sync loop")
    current_live_nodes = get_worker_nodes()

    live_state_nodes = Enum.filter(state, fn node -> Enum.member?(current_live_nodes, node) end)

    missing_nodes =
      Enum.filter(current_live_nodes, fn node -> !Enum.member?(live_state_nodes, node) end)

    Task.async(fn ->
      Process.sleep(@loop_time)
      GenServer.cast(__MODULE__, :loop)
    end)

    new_state = live_state_nodes ++ missing_nodes
    count = length(new_state)

    case count do
      0 -> Logger.error("No worker nodes available")
      _ -> Logger.debug("Got #{count} node(s)")
    end

    {:noreply, new_state}
  end

  @impl true
  def handle_cast(_, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    case state do
      [] ->
        {:reply, :error, state}

      [node] ->
        {:reply, {:ok, node}, state}

      _ ->
        [node | tail] = state
        {:reply, {:ok, node}, tail ++ [node]}
    end
  end

  defp get_worker_nodes do
    Node.list() |> Enum.filter(fn node -> String.contains?(Atom.to_string(node), "worker") end)
  end
end
