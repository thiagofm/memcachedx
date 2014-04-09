defmodule Memcachedx.Packet.Builder do
  @moduledoc """
  Builds a protocol request

  ## Example

      Memcachedx.Packet.Builder.request([:get])

  Returns:

      Some hex

  Which is the binary needed to do the desired request to memcached.

  From memcached's binary protocol info:

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
      Memcachedx.Packet.Header.magic(:request)                    ,
      Memcachedx.Packet.Header.opcode(:get)                       ,
      Memcachedx.Packet.Header.key_length(key)          :: [size(2), unit(8)],
      Memcachedx.Packet.Header.extra_length(:get)       ,
      Memcachedx.Packet.Header.data_type                          ,
      Memcachedx.Packet.Header.reserved                           :: [size(2), unit(8)],
      Memcachedx.Packet.Header.total_body_length(0, key, 0)   :: [size(4), unit(8)],
      Memcachedx.Packet.Header.opaque(opaque)           :: [size(4), unit(8)],
      Memcachedx.Packet.Header.cas(cas)                 :: [size(8), unit(8)],
      key                                                         :: binary
    >>
  end
end
