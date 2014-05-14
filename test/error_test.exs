defmodule Memcachedx.ErrorTest do
  use ExUnit.Case

  test 'basic' do
    assert_raise Memcachedx.Error, fn ->
      raise Memcachedx.Error
    end
  end
end
