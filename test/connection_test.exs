defmodule Memcachedx.ConnectionTest do
  use ExUnit.Case

  #setup do
    #Memcachedx.TestHelper.memcached_up
    #:ok
  #end

  #teardown do
    #Memcachedx.TestHelper.memcached_down
    #:ok
  #end

  #test :start_link do
    #{:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    #assert pid != nil
  #end

  #test :stop do
    #{:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    #assert Memcachedx.Connection.stop(pid) == :ok
  #end

  #test :tcp_closed do
    #{:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    #Memcachedx.TestHelper.memcached_down

    #assert { :noproc, _ } = catch_exit( Memcachedx.Connection.stop(pid) )
  #end

  #test :set do
    #{:ok, pid} = Memcachedx.Connection.start_link([hostname: "localhost", port: 11211])
    #assert Memcachedx.Connection.set(pid, "Hello", "World") == {:ok, :stored}
  #end
end
