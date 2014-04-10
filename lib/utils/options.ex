defmodule Memcachedx.Utils.Options do
  @doc """
  Initialize variables included in the vars list as 0 or empty string instead
  of nil
  """
  def initialize_vars(options, vars) do
    Enum.reduce(vars, [], fn (var, opt) ->
      if options[var] == nil do
        case var do
          :key -> opt = Keyword.merge(opt, [{var, ""}])
          :value -> opt = Keyword.merge(opt, [{var, ""}])
          _ -> opt = Keyword.merge(opt, [{var, 0}])
        end
      else
        opt = Keyword.merge(opt, [{var, options[var]}])
      end
      opt
    end)
  end
end
