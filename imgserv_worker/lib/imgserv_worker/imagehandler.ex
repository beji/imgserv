defmodule ImgservWorker.ImageHandler do
  require Logger

  @sourcepath "/tmp/wip"
  @targetpath "/tmp/done"

  @spec pipeline(String.t(), [key: String.t()] | [], binary()) ::
          {:ok, binary()} | {:error, :file.posix()}
  def pipeline(hash, format, imagedata) when is_bitstring(hash) and is_list(format) and is_binary(imagedata) do
    File.mkdir(@sourcepath)
    File.mkdir(@targetpath)
    sourcefile = "#{@sourcepath}/#{hash}"
    :ok = File.write(sourcefile, imagedata)

    result =
      Mogrify.open(sourcefile)
      |> walk_pipeline(format)
      |> Mogrify.save(path: "#{@targetpath}/#{hash}")

    File.read(result.path)
  end

  @spec make_hash(String.t(), String.t()) :: String.t()
  def make_hash(format, name) when is_bitstring(format) and is_bitstring(name) do
    base = "#{format}/#{name}"
    :crypto.hash(:md5, base) |> Base.encode16(case: :lower)
  end

  def testimage() do
    Application.app_dir(:imgserv_worker, "priv/testimage.jpg")
    |> File.read!()
  end

  @spec walk_pipeline(Mogrify.Image.t(), [key: String.t()] | [key: binary()] | []) :: Mogrify.Image.t()
  def walk_pipeline(image, []) when is_map(image) do
    image
  end

  def walk_pipeline(image, pipeline) when is_map(image) and is_list(pipeline) do
    [head | tail] = pipeline
    image_after_step = image |> handle_step(head)
    walk_pipeline(image_after_step, tail)
  end

  @spec handle_step(Mogrify.Image.t(), {atom(), String.t()}) :: Mogrify.Image.t()
  def handle_step(image, {:resize_fill, args}) when is_map(image) and is_bitstring(args) do
    Logger.info("resize_fill")
    image |> Mogrify.resize_to_fill(args)
  end

  def handle_step(image, {:resize_limit, args}) when is_map(image) and is_bitstring(args) do
    Logger.info("resize_limit")
    image |> Mogrify.resize_to_limit(args)
  end

  def handle_step(image, {:background, args}) when is_map(image) and is_bitstring(args) do
    Logger.info("background")
    image |> Mogrify.custom("background", args)
  end

  def handle_step(image, {unknown_step, _unknown_args}) do
    Logger.error("Unkown step #{unknown_step} in Pipeline!")
    image
  end
end
