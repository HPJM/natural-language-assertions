# NaturalLanguageAssertions

This project is meant to add natural language assertions so that testing can be done in plain English.

## Examples

```elixir
defmodule Example do
  use NaturalLanguageAssertions

  assert_natural list: [1, 2, 3] do
    list should contain 2
    list contains 2
    list should contain 100
    list contains 100
  end

  assert_natural collection: ["dog", "cat"] do
    collection includes 3
    collection should include 3
    collection includes "dog"
    collection should include "cat"
  end

  assert_natural collection: [:hello, :world] do
    collection has :hello
    collection should have :hello
    collection has :yellow
    collection should have :yellow
  end

  def results do
    get_results()
  end

end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `natural_language_assertions` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:natural_language_assertions, "~> 0.1.0"}
  ]
end
```
