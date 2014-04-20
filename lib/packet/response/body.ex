defmodule Memcachedx.Packet.Response.Body do
  @moduledoc """
  Builds up the body of a packet to be sent to talk with the memcached server.
  """

  def body_parser(body, params) do
    keys = extra_vars_for(params[:opcode])
    size = Enum.count(keys)
    total_body = params[:total_body]
    extra_length = params[:extra_length]

    params = Enum.reduce(keys, [], fn (item, acc) ->
      case item do
        :value -> acc = acc ++ [value: Kernel.list_to_bitstring(Enum.slice(body, extra_length, total_body))]
      end
      acc
    end)

    params
  end

  def flags(message, params) do
    if params[:extra_length] > 0 do
      params = params ++ [flags: Enum.slice(message, 24, 4)]
    end

    params
  end

  def body(message, params) do
    params = params ++ body_parser(Enum.slice(message, 24, params[:total_body]), params)
  end

  def merge_res(message, params) do
    if Enum.count(message) > 24 do
      params = flags(message, params)
      params = body(message, params)
    end
    params
  end

  @doc """
  Returns the necessary extra vars for the defined opcode
  """
  def extra_vars_for(opcode) do
    case opcode do
      opcode when opcode in [:incr, :decr] -> [:value]
      opcode when opcode in [:delete] -> [:value]
      opcode when opcode in [:get] -> [:value]
      _ -> []
    end
  end
end
