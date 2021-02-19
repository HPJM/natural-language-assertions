defmodule NaturalLanguageAssertions do
  @list_verbs_plural [:includes, :contains, :has]
  @list_verbs_singular [:include, :contain, :have]

  @verbs @list_verbs_plural ++ @list_verbs_singular

  def verb_label(verb, value, :ok), do: "#{verb} #{inspect(value)}"
  def verb_label(verb, value, :fail), do: "doesn't #{verb} #{inspect(value)}"

  defp list_label_prefix(list, key) do
    "#{key} #{inspect(list)}" <> " "
  end
  defp get_label(list, key, verb, value, status) do
    list_label_prefix(list, key) <> get_list_label(verb, value, status)
  end


  for {singular, plural} <- Enum.zip(@list_verbs_singular, @list_verbs_plural) do
    defp get_list_label(unquote(singular), value, :ok) do
      verb_label(unquote(plural), value, :ok)
    end

    defp get_list_label(unquote(plural), value, :ok) do
      verb_label(unquote(plural), value, :ok)
    end

    defp get_list_label(unquote(plural), value, :fail) do
      verb_label(unquote(singular), value, :fail)
    end

    defp get_list_label(unquote(singular), value, :fail) do
      verb_label(unquote(singular), value, :fail)
    end
  end

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [assert_natural: 2]
      Module.register_attribute(__MODULE__, :results, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    results = Module.get_attribute(env.module, :results) |> Enum.reverse()

    quote do
      def get_results do
        unquote(results)
      end
    end
  end

  defp assert_in(bindings, key, verb, value) do
    value = if is_atom(value), do: Keyword.get(bindings, value, value), else: value
    collection = bindings[key] || []
    result? = value in collection
    status = if result?, do: :ok, else: :fail
    label = get_label(collection, key, verb, value, status)

    quote bind_quoted: [value: value, label: label, status: status], unquote: true do
      @results {status, label}
      {status, label}
    end
  end

  defmacro assert_natural(bindings, do: block) do
    Macro.prewalk(block, &prewalk(&1, bindings))
  end

  defp prewalk({binding_key, _, [{:should, _, [{verb, _, [{value, _, _}]}]}]}, bindings) when verb in @verbs do
    assert_in(bindings, binding_key, verb, value)
  end

  defp prewalk({binding_key, _, [{:should, _, [{verb, _, [value]}]}]}, bindings) when verb in @verbs do
    assert_in(bindings, binding_key, verb, value)
  end

  defp prewalk({binding_key, _, [{verb, _, [{value, _, _}]}]}, bindings) when verb in @verbs do
    assert_in(bindings, binding_key, verb, value)
  end

  defp prewalk({binding_key, _, [{verb, _, [value]}]}, bindings) when verb in @verbs do
    assert_in(bindings, binding_key, verb, value)
  end

  defp prewalk(ast, _bindings), do: ast
end
