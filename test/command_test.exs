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

  test 'get success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Connection.run(pid, [:set, [key: "Hello", value: "World", flags: 0, expiry: 0]])
    assert Command.get(pid, "Hello") == [ok: [opcode: :get, key_length: 0, extras_length: 4, total_body_length: 9, opaque: 0, cas: 1, extras: 0, key: "", value: "World"]]
  end

  test 'get error' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Command.get(pid, "Hello") == [error: [opcode: :get, key_length: 0, extras_length: 0, total_body_length: 9, opaque: 0, cas: 0, extras: 0, key: "", value: "Not found", error: "Key not found"]]
  end

  test 'get! success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.set(pid, "Hello", "World")
    assert Command.get!(pid, "Hello") == "World"
  end

  test 'get! error - key not found' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert_raise Memcachedx.Error, "Key not found", fn ->
      Command.get!(pid, "Hello")
    end
  end

  test 'set success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.set(pid, "Hello", "World")
    assert Command.get(pid, "Hello") == [ok: [opcode: :get, key_length: 0, extras_length: 4, total_body_length: 9, opaque: 0, cas: 1, extras: 0, key: "", value: "World"]]
  end

  test 'set! success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Command.set!(pid, "Hello", "World") == true
  end

  test 'add success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.add(pid, "Hello", "World")
    assert Command.get(pid, "Hello") == [ok: [opcode: :get, key_length: 0, extras_length: 4, total_body_length: 9, opaque: 0, cas: 1, extras: 0, key: "", value: "World"]]
  end

  test 'add! success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert Command.add!(pid, "Hello", "World") == true
  end

  test 'add error' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.add!(pid, "Hello", "World")
    assert Command.add(pid, "Hello", "World") == [error: [opcode: :add, key_length: 0, extras_length: 0, total_body_length: 20, opaque: 0, cas: 0, extras: 0, key: "", value: "Data exists for key.", error: "Key exists"]]
  end

  test 'add! error' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.add!(pid, "Hello", "World")
    assert_raise Memcachedx.Error, "Key exists", fn ->
      Command.add!(pid, "Hello", "World")
    end
  end

  test 'delete success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.set(pid, "Hello", "World")
    assert Command.delete(pid, "Hello") == [ok: [opcode: :delete, key_length: 0, extras_length: 0, total_body_length: 0, opaque: 0, cas: 0, extras: 0, key: "", value: ""]]
  end

  test 'delete! success' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    Command.set(pid, "Hello", "World")
    assert Command.delete!(pid, "Hello") == true
  end

  test 'delete! error - key not found' do
    {:ok, pid} = Connection.start_link([hostname: "localhost", port: 11211])
    assert_raise Memcachedx.Error, "Key not found", fn ->
      Command.delete!(pid, "Hello")
    end
  end
end
