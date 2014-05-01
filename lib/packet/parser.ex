defmodule Memcachedx.Packet.Parser do
  @moduledoc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def body(params, body) do
    key_length = params[:key_length]
    value_length = params[:total_body_length] - params[:key_length] - params[:extras_length]

    # Solves problem with getk/getkq having the wrong total_body_length as the
    # total_body_length should be (extras_length + key_length + value_length)
    if params[:opcode] == :getk do
      value_length = params[:total_body_length] - params[:extras_length]
    end

    if key_length > 0 do
      <<
        key :: [binary, size(key_length)],
        body :: binary
      >> = body
    else
      key = ""
    end

    if value_length > 0 do
      <<
        value :: [binary, size(value_length)],
        body :: binary
      >> = body
    else
      value = ""
    end

    params = params ++ [key: key, value: value]

    params
  end

  def status(status) do
    if status == 0 do
      status = :ok
    else
      status = :error
    end
  end

  def recur_response(message, acc) do
    {params, status, rest} = Header.top(message)

    if Kernel.byte_size(rest) > 0 do
      {params, rest} = Header.middle(params, rest)
      {params, body, rest} = Header.bottom(params, rest)
      params = body(params, body)
    end

    result = acc ++ [{status(status), params}]

    if Kernel.byte_size(rest) > 0 do
      result = recur_response(rest, result)
    end

    result
  end

  def response(message) do
    recur_response(message, [])
  end
end
