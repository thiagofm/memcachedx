defmodule Memcachedx.ConnectionTest do
  use ExUnit.Case

  test :start_link do
    #{:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    #assert pid == 0
  end
end
