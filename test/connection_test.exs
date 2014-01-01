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
    :erlang.process_flag :trap_exit, true
    {:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    Memcachedx.TestHelper.memcached_down

    # Here it should exit the process
    IO.inspect Memcachedx.Connection.stop(pid)
  end
end
