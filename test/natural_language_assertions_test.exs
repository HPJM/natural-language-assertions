defmodule NaturalLanguageAssertionsTest do
  use ExUnit.Case
  doctest NaturalLanguageAssertions

  test "greets the world" do
    assert NaturalLanguageAssertions.hello() == :world
  end
end
