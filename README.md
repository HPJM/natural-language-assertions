# NaturalLanguageAssertions

This project is meant to add natural language assertions so that testing can be done in plain English.

## Supported syntax

### Between
- `x is between y and z`
- `x should be between y and z`

### Equality (`y` can be literal or binding)
- `x is y`
- `x equals y`
- `x should be y`
- `x should equal y`

### Containing (`y` can be literal or binding)
- `x contains y`
- `x includes y`
- `x has y`
- `x should contain y`
- `x should include y`
- `x should have y`
## Examples

```elixir
defmodule Example do
  use NaturalLanguageAssertions

  assert_natural answer: 4 do
    answer is 4
    answer should equal 4
    answer should be between 3 and 5
  end

  assert_natural collection: [:hello, :world] do
    collection has :hello
    collection should include :hello
    collection should contain :world
  end

  assert_natural list: [:hello, :world], planet: :world, animal: :cat do
    # should fail: non-existent binding
    something has planet
    list has planet
    # should fail: non-existent binding
    list includes dog
    # should fail: not in list
    list should contain animal
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
