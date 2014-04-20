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
    assert Connection.run(pid, [:add, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10]]) == {:ok, [opcode: :add, extra_length: 0, cas: 1]}
  end

  test 'add' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:add, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [opcode: :add, extra_length: 0, cas: 1]}
  end

  test 'set from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [opcode: :set, extra_length: 0, cas: 1]}
  end

  test 'set' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]]) == {:ok, [opcode: :set, extra_length: 0, cas: 1]}
  end

  test 'delete success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [opcode: :set, key: "Hello", value: "World", flags: 0, expiry: 0]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:delete, [key: "Hello"]]) == {:ok, [opcode: :delete, extra_length: 0, cas: 0]}
  end

  test 'delete fail' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:delete, [key: "Hello"]]) == {:error, [opcode: :delete, extra_length: 0, total_body: 9, cas: 0, value: "Not found"]}
  end

  test 'incr success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "counter", value: "1", flags: 0, expiry: 0]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:incr, [key: "counter", delta: 0x01, initial: 0x00, expiration: 0x00000e10]]) == {:ok, [opcode: :incr, extra_length: 0, total_body: 8, cas: 2, value: <<0, 0, 0, 0, 0, 0, 0, 2>>]}
  end

  test 'incr when key doesn\'t exist' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:incr, [key: "counter3", delta: 0x01, initial: 0x03, expiration: 0x00000e10]]) == {:ok, [opcode: :incr, extra_length: 0, total_body: 8, cas: 1, value: <<0, 0, 0, 0, 0, 0, 0, 3>>]}
  end

  test 'get doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:get, [key: "Hello"]]) == {:ok, [opcode: :get, extra_length: 4, total_body: 9, cas: 1, flags: [0, 0, 0, 0], value: "World"]}
  end

  test 'get no defined flags' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "Hello", value: "World", expiry: 0]])
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:get, [key: "Hello"]]) == {:ok, [opcode: :get, extra_length: 4, total_body: 9, cas: 1, flags: [0,0,0,0], value: "World"]}
  end

  test 'get fail from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:get, [key: "counter3"]]) == {:error, [opcode: :get, extra_length: 0, total_body: 9, cas: 0, value: "Not found"]}
  end

  test 'quit from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:quit, []]) == {:ok, [opcode: :quit, extra_length: 0, cas: 0]}
  end

  test 'flush from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:flush, []]) == {:ok, [opcode: :flush, extra_length: 0, cas: 0]}
  end

  test 'noop from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Connection.run(pid, [:noop, []]) == {:ok, [opcode: :noop, extra_length: 0, cas: 0]}
  end

  test 'version from doc example' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    {:ok, res} = Connection.run(pid, [:version, []])
    assert Keyword.has_key?(res, :value)
  end
end
