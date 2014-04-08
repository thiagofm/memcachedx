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
end
