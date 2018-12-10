defmodule ImgservWorkerTest do
  use ExUnit.Case
  doctest ImgservWorker

  test "greets the world" do
    assert ImgservWorker.hello() == :world
  end
end
