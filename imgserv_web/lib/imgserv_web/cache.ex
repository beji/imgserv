defmodule ImgservWeb.Cache do
  use Supervisor

  require Logger

  @cache_type Application.get_env(:imgserv_web, :cache_type)
  @ets_bucket :imagecache
  @cache_time Application.get_env(:imgserv_web, :cache_ttl)

  def start_link(_args \\ []) do
    Supervisor.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    children = children()

    if @cache_type == :ets do
      Logger.debug("Creating ETS table #{@ets_bucket}")
      :ets.new(@ets_bucket, [:named_table, :public])
    end

    Supervisor.init(children, strategy: :one_for_one)
  end

  case @cache_type do
    :redis ->
      Logger.info("Redis cache enabled...")

      defp children() do
        [
          :poolboy.child_spec(:redis_worker, [
            {:name, {:local, :redis_worker}},
            {:worker_module, ImgservWeb.Redisworker},
            {:size, 5}
          ])
        ]
      end

      @spec store(String.t(), binary()) :: any()
      def store(key, value) do
        :poolboy.transaction(
          :redis_worker,
          fn pid -> GenServer.cast(pid, {:store, key, value}) end,
          2000
        )
      end

      @spec get(String.t()) :: {:ok, binary()} | :not_found
      def get(key) do
        :poolboy.transaction(:redis_worker, fn pid -> GenServer.call(pid, {:get, key}) end, 2000)
      end

      @spec exists(String.t()) :: :ok | :not_found
      def exists(key) do
        :poolboy.transaction(
          :redis_worker,
          fn pid -> GenServer.call(pid, {:exists, key}) end,
          2000
        )
      end

      def ping() do
        :poolboy.transaction(:redis_worker, fn pid -> GenServer.cast(pid, {:ping}) end, 2000)
      end

    :ets ->
      Logger.info("Ets cache enabled...")
      defp children(), do: []

      @spec store(String.t(), binary()) :: any()
      def store(key, value) do
        expiration = :os.system_time(:seconds) + @cache_time
        true = :ets.insert(@ets_bucket, {key, value, expiration})
        :ok
      end

      @spec get(String.t()) :: {:ok, binary()} | :not_found
      def get(key) do
        case :ets.lookup(@ets_bucket, key) do
          [] ->
            :not_found

          list ->
            now = :os.system_time(:seconds)
            {_key, value, expiration} = hd(list)

            if now > expiration do
              :ets.delete(@ets_bucket, key)
              :not_found
            else
              {:ok, value}
            end
        end
      end

      @spec exists(String.t()) :: :ok | :not_found
      def exists(key) do
        entries = :ets.lookup(@ets_bucket, key)

        if length(entries) > 0 do
          now = :os.system_time(:seconds)
          {_key, _value, expiration} = hd(entries)

          if now > expiration do
            :ets.delete(@ets_bucket, key)
            :not_found
          else
            :ok
          end
        else
          :not_found
        end
      end

      def ping(), do: "PONG"

    _ ->
      Logger.info("Cache disabled...")
      defp children(), do: []

      @spec store(String.t(), binary()) :: any()
      def store(_key, _value), do: :ok

      @spec get(String.t()) :: {:ok, binary()} | :not_found
      def get(_key), do: :not_found

      @spec exists(String.t()) :: :ok | :not_found
      def exists(_key), do: :not_found

      def ping(), do: "PONG"
  end
end
