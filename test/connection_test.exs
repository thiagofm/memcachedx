defmodule Memcachedx.ConnectionTest do
  use ExUnit.Case

  setup do
    Memcachedx.TestHelper.memcached_up
    :ok
  end

  teardown do
    Memcachedx.TestHelper.memcached_down
    :ok
  end

  test :start_link do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert pid != nil
  end

  test :stop do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.stop(pid) == :ok
  end

  test :tcp_closed do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    Memcachedx.TestHelper.memcached_down

    assert { :noproc, _ } = catch_exit( Memcachedx.Connection.stop(pid) )
  end

  test 'add from doc example' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:add, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10]]) == {:ok, [cas: 1]}
  end

  test 'add' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:add, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [cas: 1]}
  end

  test 'set from doc example' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [cas: 1]}
  end

  test 'set' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [cas: 1]}
  end

  test 'delete success' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    Memcachedx.Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]])
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:delete, [key: "Hello"]]) == {:ok, [cas: 0]}
  end

  test 'delete fail' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:delete, [key: "Hello"]]) == {:error, [cas: 0, total_body: 9]}
  end

  test 'incr success' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    Memcachedx.Connection.run(pid, [:set, [key: "counter", value: "1", flags: 0, expiry: 0]])
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:incr, [key: "counter", delta: 0x01, initial: 0x00, expiration: 0x00000e10]]) == {:ok, [cas: 2, total_body: 8]}
  end

  test 'incr when key doesn\'t exist' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:incr, [key: "counter3", delta: 0x01, initial: 0x03, expiration: 0x00000e10]]) == {:ok, [cas: 2, value: 0x03, total_body: 8]}
  end
end
