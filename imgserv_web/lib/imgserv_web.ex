defmodule ImgservWeb do
  @moduledoc """
  Documentation for ImgservWeb.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ImgservWeb.hello()
      :world

  """
  def hello do
    :world
  end

  @spec make_hash(String.t, String.t) :: String.t
  def make_hash(format, name) when is_binary(format) and is_binary(name) do
    base = "#{format}/#{name}"
    :crypto.hash(:md5, base) |> Base.encode16(case: :lower)
  end

  @spec testimage() :: binary()
  def testimage() do
    Application.app_dir(:imgserv_web, "priv/testimage.jpg")
  end

  @spec validate_image_exists(String.t()) :: {:ok, binary()} | :error
  def validate_image_exists(image) do
    case File.read(image) do
      {:ok, data} -> {:ok, data}
      _ -> :error
    end
  end

  @spec get_worker() :: :error | {:ok, atom()}
  def get_worker() do
    GenServer.call(ImgservWeb.Workerhandler, :get)
  end

  @spec get_db() :: :error | {:ok, atom()}
  def get_db() do
    get_node("db")
  end

  @spec get_node(String.t(), [atom]) :: :error | {:ok, atom()}
  def get_node(name, nodelist \\ Node.list()) do
    nodes =
      nodelist |> Enum.filter(fn node -> String.contains?(Atom.to_string(node), name) end)
    case nodes do
      [] ->
        :error

      _ ->
        nodecount = Enum.count(nodes)
        n = Enum.random(0..nodecount)
        {:ok, Enum.at(nodes, n - 1)}
    end
  end

  @spec find_format_steps(String.t()) :: [key: String.t()] | []
  def find_format_steps(format) do
    formats = ImgservWeb.Formatstore.get_formats()
    Enum.find_value(formats, [], fn {k, v} -> k == format && v end)
  end
end
