defmodule Memcachedx.Utils.OptionsTest do
  use ExUnit.Case

  test 'initialize_vars' do
    options = [key: "Hello", value: "World"]
    vars = [:key, :value, :cas, :flags]
    require Memcachedx.Utils.Options
    Memcachedx.Utils.Options.initialize_vars(options, vars)
    assert key == "Hello"
    assert value == "World"
    assert cas == 0
    assert flags == 0
  end
end
