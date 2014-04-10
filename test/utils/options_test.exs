defmodule Memcachedx.Utils.OptionsTest do
  use ExUnit.Case

  test 'initialize_vars' do
    options = [key: "Hello", value: "World"]
    vars = [:key, :value, :cas, :flags]
    options = Memcachedx.Utils.Options.initialize_vars(options, vars)
    assert options[:key] == "Hello"
    assert options[:value] == "World"
    assert options[:cas] == 0
    assert options[:flags] == 0
  end
end
