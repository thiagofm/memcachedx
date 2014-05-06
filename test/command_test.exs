defmodule Memcachedx.CommandTest do
  use ExUnit.Case
  alias Memcachedx.Command, as: Command
  alias Memcachedx.Connection, as: Connection

  setup do
    Memcachedx.TestHelper.memcached_up
    :ok
  end

  teardown do
    Memcachedx.TestHelper.memcached_down
    :ok
  end

  test 'get simple' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Command.get(pid, "Hello") == {:ok, "World"}
  end
end
