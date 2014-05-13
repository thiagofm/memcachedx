defmodule Memcachedx.Command do
  def get!(pid, key) do
    case get(pid, key) do
      [{:ok, params}] -> params[:value]
      [{:error, params}] ->
        case params[:value] do
          "Not found" -> ""
          "" -> raise "Foo" # TODO
        end
    end
  end

  def get(pid, key) do
    case Memcachedx.Connection.run(pid, [:get, [key: key]]) do
      res -> res
    end
  end

  def set(pid, key, value) do
    case Memcachedx.Connection.run(pid, [:set, [key: key, value: value]]) do
      res -> res
    end
  end

  def set!(pid, key, value) do
    case set(pid, key, value) do
      [{:ok, params}] -> true
      [{:error, params}] -> false
    end
  end
end
