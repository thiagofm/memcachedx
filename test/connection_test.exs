defmodule Memcachedx.ConnectionTest do
  use ExUnit.Case
  alias Memcachedx.Connection, as: Connection

  setup do
    Memcachedx.TestHelper.memcached_up
    :ok
  end

  teardown do
    Memcachedx.TestHelper.memcached_down
    :ok
  end

  test :start_link do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert pid != nil
  end

  test :stop do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.stop(pid) == :ok
  end

  test :tcp_closed do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Memcachedx.TestHelper.memcached_down

    assert { :noproc, _ } = catch_exit( Connection.stop(pid) )
  end

  test 'add from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:add, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10]]) == {:ok, [cas: 1, opcode: :add]}
  end

  test 'add' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:add, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [cas: 1, opcode: :add]}
  end

  test 'set from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [cas: 1, opcode: :set]}
  end

  test 'set' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [cas: 1, opcode: :set]}
  end

  test 'delete success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0, opcode: :set]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:delete, [key: "Hello"]]) == {:ok, [cas: 0, opcode: :delete]}
  end

  test 'delete fail' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:delete, [key: "Hello"]]) == {:error, [cas: 0, opcode: :delete, total_body: 9, value: "Not found"]}
  end

  test 'incr success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "counter", value: "1", flags: 0, expiry: 0]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:incr, [key: "counter", delta: 0x01, initial: 0x00, expiration: 0x00000e10]]) == {:ok, [cas: 2, opcode: :incr, total_body: 8, value: <<0, 0, 0, 0, 0, 0, 0, 2>>]}
  end

  test 'incr when key doesn\'t exist' do
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    assert Memcachedx.Connection.run(pid, [:incr, [key: "counter3", delta: 0x01, initial: 0x03, expiration: 0x00000e10]]) == {:ok, [cas: 1, opcode: :incr, total_body: 8, value: <<0, 0, 0, 0, 0, 0, 0, 3>>]}
  end
end
