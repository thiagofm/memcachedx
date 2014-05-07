defmodule Memcachedx.Command do
  def get(pid, key) do
    case Memcachedx.Connection.run(pid, [:get, [key: key]]) do
      [ok: params] = res -> { :ok, params[:value] }
    end
  end

  def set(pid, key, value) do
    case Memcachedx.Connection.run(pid, [:set, [key: key, value: value]]) do
      [ok: params] = res -> { :ok, [] }
    end
  end
end
