defmodule ImgservWeb.Router do
  use Plug.Router

  @cors_allowed Application.get_env(:imgserv_web, :cors_allowed)

  plug(Plug.RequestId)
  plug(Plug.Logger)
  plug(:match)
  plug(CORSPlug, origin: @cors_allowed)
  plug(:dispatch)

  require Logger

  match "/api/formats" do
    formats_encoded = Poison.encode!(%{"formats" => ImgservWeb.Formatstore.get_format_names()})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, formats_encoded)
  end

  match "/api/pipeline/:format" do
    pipeline =
      ImgservWeb.Formatstore.get_pipeline(format)
      |> Enum.map(fn {name, params} -> %{"name" => name, "params" => params} end)

    pipeline_encoded = Poison.encode!(%{"pipeline" => pipeline})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, pipeline_encoded)
  end

  match "/:format/:image" do
    hash = ImgservWeb.make_hash(format, image)

    case ImgservWeb.Cache.get(hash) do
      {:ok, data} ->
        Logger.info("serving from cache")

        conn
        |> put_resp_content_type("image/jpeg")
        |> send_resp(200, data)

      :not_found ->
        Logger.info("creating fresh image")

        with format <- ImgservWeb.find_format_steps(format),
             {:ok, imagedata} <- ImgservWeb.validate_image_exists(ImgservWeb.testimage()),
             {:ok, worker} <- ImgservWeb.get_worker(),
             {:ok, pid} <- :rpc.call(worker, ImgservWorker, :start_worker, [], 2000) do
          Logger.debug("Executing on worker #{Atom.to_string(worker)} with pid #{inspect(pid)}")

          result =
            :rpc.call(worker, ImgservWorker.Worker, :convert, [
              pid,
              hash,
              format,
              imagedata
            ])

          :rpc.cast(worker, ImgservWorker.Worker, :exit, [pid])

          case result do
            {:ok, resp} ->
              ImgservWeb.Cache.store(hash, resp)
              send_resp(conn, 200, resp)

            _ ->
              send_resp(conn, 404, "oops")
          end
        else
          error ->
            IO.inspect(error)
            send_resp(conn, 404, "oops")
        end
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
