defmodule OliBotTest do
  use ExUnit.Case
  doctest OliBot

  test "greets the world" do
    assert OliBot.hello() == :world
  end
end
