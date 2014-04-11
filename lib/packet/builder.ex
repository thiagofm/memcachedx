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
    options = Memcachedx.Utils.Options.initialize_vars(options)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end

  @doc """
  Builds a binary request for an add, set or replace

  Request:

  MUST have extras.
  MUST have key.
  MAY have value.
  """
  def request([opcode, options]) when opcode in [:add, :set, :replace] do
    vars = [:flags, :expiry]
    options = Memcachedx.Utils.Options.initialize_vars(options, vars)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a delete

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:delete] do
    options = Memcachedx.Utils.Options.initialize_vars(options)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a incr/decr

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:incr, :decr] do
    vars = [:delta, :initial, :expiration]
    options = Memcachedx.Utils.Options.initialize_vars(options, vars)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a quit

  Request:

  MUST NOT have extras.
  MUST NOT have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:quit] do
    options = Memcachedx.Utils.Options.initialize_vars(options)

    Memcachedx.Packet.Header.merge_header(opcode, options) <> Memcachedx.Packet.Body.merge_body(options)
  end
end
