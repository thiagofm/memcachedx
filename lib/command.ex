defmodule Memcachedx.Command do
  def get(pid, key) do
    case Memcachedx.Connection.run(pid, [:get, [key: key]]) do
      [ok: params] = res -> { :ok, params[:value] }
    end
  end
end
