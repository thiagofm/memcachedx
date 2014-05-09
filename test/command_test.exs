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

  test 'get' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]])
    assert Command.get(pid, "Hello") == {:ok, "World"}
  end

  test 'set' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.set(pid, "Hello", "World")
    assert Command.get(pid, "Hello") == {:ok, "World"}
  end

  test 'get!' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.set(pid, "Hello", "World")
    assert Command.get!(pid, "Hello") == "World"
  end
end
