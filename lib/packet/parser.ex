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
      status = :ok
    else
      status = :error
    end
  end


  @doc """
  Parses the response recursively while there's still rest
  """
  def recursively_parse_response(message, acc) do
    {params, status, rest} = Header.parse_top(message)

    if Kernel.byte_size(rest) > 0 do
      {params, rest} = Header.parse_middle(params, rest)
      {params, body, rest} = Header.parse_bottom(params, rest)
      params = Body.parse(params, body)
    else
      rest = <<>>
    end

    result = acc ++ [{status(status), params}]

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
