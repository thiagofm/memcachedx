defmodule Memcachedx.Utils.Options do
  defmacro initialize_vars(options, vars) do
    options = quote do: var!(options)
    quote do
      Enum.each(unquote(vars), fn (v) ->
        var!(quote(v)) = unquote(options)[v]
      end)
    end
  end
end
