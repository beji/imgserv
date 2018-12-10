defmodule ImgservWeb.Formatstore do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, [])
  end

  @impl true
  def init(_args) do
    children = [
      ImgservWeb.Formatstore.StoreHandler
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec get_format_names() :: [String.t]
  def get_format_names() do
    store = ImgservWeb.Formatstore.StoreHandler.get_store()

    :ets.tab2list(store)
    |> Enum.map(fn {name, _pipeline} -> name end)
  end

  @spec get_formats() :: [{String.t, [key: String.t]}]
  def get_formats() do
    # GenServer.call(ImgservWeb.Formatstore.Store, :get)
    store = ImgservWeb.Formatstore.StoreHandler.get_store()
    :ets.tab2list(store)
  end

  @spec get_pipeline(String.t) :: [key: String.t]
  def get_pipeline(format) when is_bitstring(format) do
    # GenServer.call(ImgservWeb.Formatstore.Store, {:get_pipeline, format})
    store = ImgservWeb.Formatstore.StoreHandler.get_store()

    case :ets.lookup(store, format) do
      [] -> []
      [{_, pipeline} | _tail] -> pipeline
    end
  end

  # defp get_ets_keys_lazy(table_name) when is_atom(table_name) do
  #   eot = :"$end_of_table"

  #   Stream.resource(
  #       fn -> [] end,

  #       fn acc ->
  #           case acc do
  #               [] ->
  #                   case :ets.first(table_name) do
  #                       ^eot -> {:halt, acc}
  #                       first_key -> {[first_key], first_key}
  #                   end

  #               acc ->
  #                   case :ets.next(table_name, acc) do
  #                       ^eot -> {:halt, acc}
  #                       next_key -> {[next_key], next_key}
  #                   end
  #           end
  #       end,

  #       fn _acc -> :ok end
  #   )
  # end
end
