defmodule ImgservWebTest do
  use ExUnit.Case
  doctest ImgservWeb

  import Mock

  describe "validate_image_exists" do
    test "returns ok if an image is found" do
      with_mock(File, [read: fn(name) -> {:ok, name} end]) do
        assert ImgservWeb.validate_image_exists("stuhl") == {:ok, "stuhl"}
      end
    end

    test "returns error nothing found" do
      assert ImgservWeb.validate_image_exists("stuhl") == :error
    end

  end

  describe "get_node" do
    test "returns a node starting with db if one exists"  do
      nodelist = [:"db@127.0.0.1", :"worker@127.0.0.1"]
      assert ImgservWeb.get_node("db", nodelist) == {:ok, :"db@127.0.0.1"}
    end

    test "returns error if the targeted node doesn't exist"  do
      nodelist = []
      assert ImgservWeb.get_node("db", nodelist) == :error
    end
  end

  describe "find_format_steps" do

    test "it returns the pipeline for the given format" do
      with_mock(ImgservWeb.Formatstore, [get_formats: fn() ->
        mock_formats()
      end]) do
        assert ImgservWeb.find_format_steps("test") == [resize_limit: "800x200", background: "#000000"]
        assert ImgservWeb.find_format_steps("original") == []
      end
    end

    test "it returns an empty list if the format is unknown" do
      with_mock(ImgservWeb.Formatstore, [get_formats: fn() ->
        mock_formats()
      end]) do
        assert ImgservWeb.find_format_steps("randomletters") == []
      end
    end

  end

  defp mock_formats do
    [{"test", [resize_limit: "800x200", background: "#000000"]},
    {"thumbnail", [resize_limit: "200x200"]},
    {"original", []}]
  end

end
