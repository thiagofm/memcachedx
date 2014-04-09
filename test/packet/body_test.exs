defmodule Memcachedx.Packet.BodyTest do
  use ExUnit.Case

  test 'build get' do
    options = [key: "Hello"]
    assert Memcachedx.Packet.Body.build(:get, options) == << 0x48, 0x65, 0x6c, 0x6c, 0x6f >>
  end

  test 'build add' do
    options = [key: "Hello", value: "World", flags: 0xdeadbeef, expiry: 0x00000e10]
    assert Memcachedx.Packet.Body.build(:add, options) == <<
      0xde, 0xad, 0xbe, 0xef,
      0x00, 0x00, 0x0e, 0x10,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>
  end
end
