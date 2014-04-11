defmodule Memcachedx.Packet.Builder do
  @moduledoc """
  Builds a protocol request

  ## Example

      Memcachedx.Packet.Builder.request([:get])

  Returns:

      Some hex

  Which is the binary needed to do the desired request to memcached.

  From memcached's binary protocol info:

  """

  @doc """
  Builds a binary request for a get

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode == :get do
    vars = [:opaque, :key, :cas, :extras, :key, :value]
    options = Memcachedx.Utils.Options.initialize_vars(options, vars)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end

  @doc """
  Builds a binary request for an add

  Request:

  MUST have extras.
  MUST have key.
  MAY have value.
  """
  def request([opcode, options]) when opcode in [:add, :set, :replace] do
    vars = [:opaque, :cas, :key, :value, :extras, :flags, :expiry]
    options = Memcachedx.Utils.Options.initialize_vars(options, vars)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end
end
