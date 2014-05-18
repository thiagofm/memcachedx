defmodule Memcachedx.Command do
  @moduledoc """
  Executes a command in memcached
  """

  @doc """
  Gets the value of a key in memcached
  """
  def get!(pid, key) do
    case get(pid, key) do
      [{:ok, params}] -> params[:value]
      [{:error, params}] -> raise Memcachedx.Error
    end
  end

  @doc """
  Gets the value of a key in memcached
  """
  def get(pid, key) do
    case Memcachedx.Connection.run(pid, [:get, [key: key]]) do
      res -> res
    end
  end

  @doc """
  Sets a new key/value pair in memcached
  """
  def set(pid, key, value) do
    case Memcachedx.Connection.run(pid, [:set, [key: key, value: value]]) do
      res -> res
    end
  end

  @doc """
  Sets a new key/value pair in memcached
  """
  def set!(pid, key, value) do
    case set(pid, key, value) do
      [{:ok, params}] -> true
      [{:error, params}] -> raise Memcachedx.Error
    end
  end

  @doc """
  Deletes a new key/value pair in memcached
  """
  def delete(pid, key) do
    case Memcachedx.Connection.run(pid, [:delete, [key: key]]) do
      res -> res
    end
  end
end
