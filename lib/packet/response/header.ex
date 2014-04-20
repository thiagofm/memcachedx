defmodule Memcachedx.Packet.Response.Header do
  @moduledoc """
  Builds up the header of a packet to be sent to talk with the memcached server.
  """

  def status(message) do
    status = slice_and_sum(message, 6, 2)
    case status do
      0 -> :ok
      _ -> :error
    end
  end

  def extra_length(message, params) do
    params = params ++ [extra_length: slice_and_sum(message, 4, 1)]
  end

  def opcode(message, params) do
    opcode = case Enum.at(message, 1) do
      0x00 -> :get
      0x01 -> :set
      0x02 -> :add
      0x03 -> :replace
      0x04 -> :delete
      0x05 -> :incr
      0x06 -> :decr
      0x07 -> :quit
      0x08 -> :flush
      0x0A -> :noop
      0x0B -> :version
      0x0D -> :getkq
      0x0E -> :append
      0x0F -> :prepend
      0x10 -> :stat
      0x11 -> :setq
      0x12 -> :addq
      0x13 -> :replaceq
      0x14 -> :deleteq
      0x15 -> :incrq
      0x16 -> :decrq
    end

    params = params ++ [opcode: opcode]
    params
  end

  def total_body(message, params) do
    if slice_and_sum(message, 8, 4) > 0 do
      params = params ++ [total_body: Enum.slice(message, 8, 4) |> Enum.reduce(&+/2)]
    end
    params
  end

  def cas(message, params) do
    params = params ++ [cas: slice_and_sum(message, 16,8)]
  end

  def merge_res(message, params) do
    params = opcode(message, params)
    params = extra_length(message, params)
    params = total_body(message, params)
    params = cas(message, params)
    params
  end

  defp slice_and_sum(message, from, to) do
    Enum.slice(message, from, to) |> Enum.reduce(&+/2)
  end
end
