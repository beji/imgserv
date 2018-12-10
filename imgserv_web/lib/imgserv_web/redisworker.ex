defmodule ImgservWeb.Redisworker do
  use GenServer

  @cache_time Application.get_env(:imgserv_web, :cache_ttl)

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [])
  end

  @impl true
  def init(_) do
    {:ok, conn} = Redix.start_link(host: "localhost", port: 6379)
    {:ok, conn}
  end

  @impl true
  def handle_call({:get, key}, _from, conn) when is_bitstring(key) do
    case Redix.command(conn, ["GET", key]) do
      {:ok, nil} -> {:reply, :not_found, conn}
      {:ok, data} -> {:reply, {:ok, data}, conn}
      _ -> {:reply, :not_found, conn}
    end
  end

  @impl true
  def handle_call({:exists, key}, _from, conn) when is_bitstring(key) do
    case Redix.command(conn, ["EXISTS", key]) do
      {:ok, 1} -> {:reply, :ok, conn}
      {:ok, _} -> {:reply, :not_found, conn}
      _ -> {:reply, :not_found, conn}
    end
  end

  @impl true
  def handle_call(_message, _from, conn) do
    {:reply, :ok, conn}
  end

  @impl true
  def handle_cast({:store, key, value}, conn) when is_bitstring(key) and is_binary(value) do
    Logger.info("storing #{key} in redis!")
    {:ok, ["OK", 1]} = Redix.pipeline(conn, [["SET", key, value], ["EXPIRE", key, @cache_time]])
    {:noreply, conn}
  end

  @impl true
  def handle_cast({:ping}, conn) do
    Logger.info("pinging redis!")
    {:ok, "PONG"} = Redix.command(conn, ["PING"])
    {:noreply, conn}
  end
end
