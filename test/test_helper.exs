defmodule Memcachedx.TestHelper do
  def memcached_up do
    IO.inspect System.cmd("sudo memcached &")
    sleep
  end

  def memcached_down do
    IO.inspect System.cmd("sudo pkill memcached")
    sleep
  end

  # Sleep to wait for memcached process to be set up
  defp sleep do
    :timer.sleep 50
  end
end

ExUnit.start
