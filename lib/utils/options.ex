defmodule Memcachedx.Utils.Options do
  @moduledoc """
  Initialize variables included in the vars list as 0 or empty string instead
  of nil
  """
  def initialize_vars(options) do
    initialize_vars(options, [])
  end

  def initialize_vars(options, vars) do
    default_vars_list = [:extras, :key, :value, :opaque, :cas]
    vars = vars ++ default_vars_list

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
