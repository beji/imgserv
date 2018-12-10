defmodule ImgservDb.Table.Format do
  @moduledoc """
  """

  require Logger

  use Memento.Table,
    attributes: [:id, :name, :pipeline],
    type: :ordered_set,
    index: [:name],
    autoincrement: true

  @spec create([{String.t(), [key: String.t()] | []}]) :: {:error, any()} | {:ok, %ImgservDb.Table.Format{}}
  def create(entries) when is_list(entries) do
    Memento.transaction(fn ->
      entries
      |> Enum.each(fn {name, pipeline} ->
        Logger.info(fn -> "Creating entry for #{name}" end)
        Memento.Query.write(%ImgservDb.Table.Format{name: name, pipeline: pipeline})
      end)
    end)
  end

  @spec create(String.t(), [key: String.t()] | []) :: {:error, any()} | {:ok, %ImgservDb.Table.Format{}}
  def create(name, pipeline) when is_bitstring(name) and is_list(pipeline) do
    Memento.transaction(fn ->
      Logger.info(fn -> "Creating entry for #{name}" end)
      Memento.Query.write(%ImgservDb.Table.Format{name: name, pipeline: pipeline})
    end)
  end

  @spec get_all() :: {:error, any()} | {:ok, any()}
  def get_all() do
    formats = Memento.transaction(fn ->
      Memento.Query.all(ImgservDb.Table.Format)
    end)
    case formats do
      {:error, _} ->
        Logger.warn(fn -> "Failed to get formats from the database" end)
        formats
      {:ok, data} ->
        {:ok, Enum.map(data, fn format -> {format.name, format.pipeline} end)}
    end
  end

end
