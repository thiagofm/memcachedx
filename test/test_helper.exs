defmodule Memcachedx.TestHelper do
  def memcached_up do
    if System.get_env("TEST_ENV") == "travis" do
      System.cmd("sudo service memcached start")
    else
      System.cmd("memcached &")
    end

    :timer.sleep 100
  end

  def memcached_down do
    if System.get_env("TEST_ENV") == "travis" do
      System.cmd("sudo pkill memcached")
    else
      System.cmd("pkill memcached")
    end
  end
end

ExUnit.start
