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
    opaque = options[:opaque] || 0
    cas = options[:cas] || 0
    key = options[:key]

    <<
      Memcachedx.Packet.Header.magic(:request)                                     ,
      Memcachedx.Packet.Header.opcode(opcode)                                      ,
      Memcachedx.Packet.Header.key_length(key)                :: [size(2), unit(8)],
      Memcachedx.Packet.Header.extra_length(opcode)                                ,
      Memcachedx.Packet.Header.data_type                                           ,
      Memcachedx.Packet.Header.reserved                       :: [size(2), unit(8)],
      Memcachedx.Packet.Header.total_body_length(0, key, 0)   :: [size(4), unit(8)],
      Memcachedx.Packet.Header.opaque(opaque)                 :: [size(4), unit(8)],
      Memcachedx.Packet.Header.cas(cas)                       :: [size(8), unit(8)],
      key                                                     :: binary
    >>
  end

  @doc """
  Builds a binary request for a set

  Request:

  MUST have extras.
  MUST have key.
  MAY have value.
  """
  def request([opcode, options]) when opcode == :add do
    opaque = options[:opaque] || 0
    cas = options[:cas] || 0
    key = options[:key]
    value = options[:value] || 0
    extras = options[:extras] || 0
    flags = options[:flags] || 0
    expiry = options[:expiry] || 0

    <<
      Memcachedx.Packet.Header.magic(:request)                                     ,
      Memcachedx.Packet.Header.opcode(opcode)                                      ,
      Memcachedx.Packet.Header.key_length(key)                :: [size(2), unit(8)],
      Memcachedx.Packet.Header.extra_length(opcode)                                ,
      Memcachedx.Packet.Header.data_type                                           ,
      Memcachedx.Packet.Header.reserved                       :: [size(2), unit(8)],
      Memcachedx.Packet.Header.total_body_length(extras, key, value):: [size(4), unit(8)],
      Memcachedx.Packet.Header.opaque(opaque)                 :: [size(4), unit(8)],
      Memcachedx.Packet.Header.cas(cas)                       :: [size(8), unit(8)],
      flags                                                   :: [size(4), unit(8)],
      expiry                                                  :: [size(4), unit(8)],
      key                                                     :: binary,
      value                                                   :: binary,
    >>
  end
end
