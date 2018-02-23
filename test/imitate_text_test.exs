defmodule ImitateTextTest do
  use ExUnit.Case
  doctest ImitateText

  test "greets the world" do
    assert ImitateText.hello() == :world
  end
end
