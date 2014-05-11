defmodule Memcachedx.Packet.Response.Body do
  @moduledoc """
  Parses the body of a packet received from the memcached server.
  """

  @doc """
  Parses the key and value from the body, if the key or value is not found it's
  set as an empty string.

  When the requests is a getk, which implies that the value length isn't
  included in the key length, it uses a different rule to calculate the value's
  length.
  """
  def parse(params, body) do
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
end
