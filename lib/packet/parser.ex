defmodule Memcachedx.Packet.Parser do
  @moduledoc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  @doc """
  The status code for the response
  """
  def status(status) do
    if status == 0 do
      :ok
    else
      :error
    end
  end

  @doc """
  Parses memcached response status into readable errors.
  """
  def readable_error(status) do
    case status do
      0x0001 -> "Key not found"
      0x0002 -> "Key exists"
      0x0003 -> "Value too large"
      0x0004 -> "Invalid arguments"
      0x0005 -> "Item not stored"
      0x0006 -> "Incr/Decr on non-numeric value."
      0x0007 -> "The vbucket belongs to another server"
      0x0008 -> "Authentication error"
      0x0009 -> "Authentication continue"
      0x0081 -> "Unknown command"
      0x0082 -> "Out of memory"
      0x0083 -> "Not supported"
      0x0084 -> "Internal error"
      0x0085 -> "Busy"
      0x0086 -> "Temporary failure"
    end
  end

  @doc """
  Parses the response recursively while there's still rest
  """
  def recursively_parse_response(message, acc) do
    {params, status_code, rest} = Header.parse_top(message)

    if Kernel.byte_size(rest) > 0 do
      {params, rest} = Header.parse_middle(params, rest)
      {params, body, rest} = Header.parse_bottom(params, rest)
      params = Body.parse(params, body)
    else
      rest = <<>>
    end

    status = status(status_code)

    if status == :error do
      params = params ++ [error: readable_error(status_code)]
    end

    result = acc ++ [{status, params}]

    if Kernel.byte_size(rest) > 0 do
      result = recursively_parse_response(rest, result)
    end

    result
  end

  @doc """
  Starts the recursively_parse_response with an accumulator
  """
  def response(message) do
    recursively_parse_response(message, [])
  end
end
