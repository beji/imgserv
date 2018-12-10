defmodule ImgservWorker do
  @moduledoc """
  Documentation for ImgservWorker.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ImgservWorker.hello()
      :world

  """
  def hello do
    :world
  end

  def start_worker do
    DynamicSupervisor.start_child(ImgservWorker.DynamicSupervisor, ImgservWorker.Worker)
  end
end
