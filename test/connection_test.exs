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
    assert Memcachedx.Connection.run(pid, [:add, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10, extras: 8]]) == {:ok, [cas: 1]}
  end

  test 'add' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:add, [key: "Hello", value: "World", flags: 0, expiry: 0, extras: 8]]) == {:ok, [cas: 1]}
  end
end
