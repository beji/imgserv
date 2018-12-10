defmodule ImgservWeb.Formatstore.StoreHandler do
  use GenServer

  require Logger

  @loop_time 10000
  @ets_bucket :formatstore

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    :ets.new(@ets_bucket, [:named_table])
    GenServer.cast(self(), :loop)
    {:ok, []}
  end

  @impl true
  def handle_cast(:loop, _state) do
    Logger.debug("#{__MODULE__} running sync loop")
    with {:ok, db} <- ImgservWeb.get_db(),
         {:ok, data} <- :rpc.call(db, ImgservDb.Table.Format, :get_all, [])
      do

      Logger.debug("#{__MODULE__} got results")
      data
      |> Enum.each(fn entry ->
        :ets.insert(@ets_bucket, entry)
      end)
    else
      :error ->
        Logger.error("Failed to get a database node")
      {:badrpc, {:EXIT, {%{message: message}, _}}} ->
        Logger.error(["Failed to get an rpc response: ", message])
      {:badrpc, reason} ->

        Logger.error("Failed to get an rpc response")
        IO.inspect(:stderr, reason, [])

      error ->
        Logger.error("Unkown error")
        IO.inspect(:stderr, error, [])
    end

    Task.async(fn ->
      Process.sleep(@loop_time)
      GenServer.cast(__MODULE__, :loop)
    end)

    {:noreply, []}
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
  def handle_call(:get_names, _from, state) do
    {:reply, Enum.map(state, fn {format, _} -> format end), state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get_pipeline, format}, _from, state) when is_bitstring(format) do
    {_, pipeline} = Enum.find(state, fn {name, _} -> format == name end)
    {:reply, pipeline, state}
  end

  def get_store do
    @ets_bucket
  end

end
