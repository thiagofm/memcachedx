defmodule Memcachedx.Packet.HeaderTest do
  use ExUnit.Case

  test :magic do
    assert Memcachedx.Packet.Header.magic(:request) == <<0x80>>
  end

  test :opcode do
    assert Memcachedx.Packet.Header.opcode(:get) == <<0x00>>
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
    assert Memcachedx.Packet.Header.extra_length(:get) == 4
    assert Memcachedx.Packet.Header.extra_length(:getkq) == 4
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
end
