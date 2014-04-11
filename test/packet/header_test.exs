defmodule Memcachedx.Packet.HeaderTest do
  use ExUnit.Case
  doctest Memcachedx.Packet.Body

  test :magic do
    assert Memcachedx.Packet.Header.magic(:request) == 0x80
  end

  test :opcode do
    assert Memcachedx.Packet.Header.opcode(:get) == 0x00
  end

  test :key_length do
    assert Memcachedx.Packet.Header.key_length("xpto") == 4
  end

  test :extra_length do
    assert Memcachedx.Packet.Header.extra_length(:version) == 0
    assert Memcachedx.Packet.Header.extra_length(:append) == 0
    assert Memcachedx.Packet.Header.extra_length(:prepend) == 0
    assert Memcachedx.Packet.Header.extra_length(:stat) == 0
    assert Memcachedx.Packet.Header.extra_length(:noop) == 0
    assert Memcachedx.Packet.Header.extra_length(:delete) == 0
    assert Memcachedx.Packet.Header.extra_length(:deleteq) == 0
    assert Memcachedx.Packet.Header.extra_length(:get) == 0
    assert Memcachedx.Packet.Header.extra_length(:getkq) == 0
    assert Memcachedx.Packet.Header.extra_length(:flush) == 4
    assert Memcachedx.Packet.Header.extra_length(:set) == 8
    assert Memcachedx.Packet.Header.extra_length(:setq) == 8
    assert Memcachedx.Packet.Header.extra_length(:add) == 8
    assert Memcachedx.Packet.Header.extra_length(:addq) == 8
    assert Memcachedx.Packet.Header.extra_length(:replace) == 8
    assert Memcachedx.Packet.Header.extra_length(:replaceq) == 8
    assert Memcachedx.Packet.Header.extra_length(:incr) == 20
    assert Memcachedx.Packet.Header.extra_length(:incrq) == 20
    assert Memcachedx.Packet.Header.extra_length(:decr) == 20
    assert Memcachedx.Packet.Header.extra_length(:decrq) == 20
  end

  test :data_type do
    assert Memcachedx.Packet.Header.data_type == 0
  end

  test :reserved do
    assert Memcachedx.Packet.Header.reserved == 0
  end

  test :total_body_length do
    assert Memcachedx.Packet.Header.total_body_length(0, "hello", "") == 5
    assert Memcachedx.Packet.Header.total_body_length(0, "hello", "world") == 10
    assert Memcachedx.Packet.Header.total_body_length(2, "hello", "world") == 12
  end

  test :opaque do
    assert Memcachedx.Packet.Header.opaque(1)
  end

  test :cas do
    assert Memcachedx.Packet.Header.cas(1)
  end

  test :merge_header do
    opcode = :get
    options = [value: "", key: "Hello", extras: 0, cas: 0, opaque: 0]
    assert Memcachedx.Packet.Header.merge_header(opcode, options) == <<
      0x80, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00
    >>
  end
end
