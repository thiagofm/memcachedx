defmodule Memcachedx.Packet.BodyTest do
  use ExUnit.Case
  doctest Memcachedx.Packet.Body

  test 'merge_body set example' do
    options = [key: "Hello", value: "World", flags: 0xdeadbeef, expiry: 0x00000e10]
    assert Memcachedx.Packet.Body.merge_body(options) == <<
      0xde, 0xad, 0xbe, 0xef,
      0x00, 0x00, 0x0e, 0x10,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>
  end

  test 'merge_body get example' do
    options = [key: "Hello"]
    assert Memcachedx.Packet.Body.merge_body(options) == <<
      0x48, 0x65, 0x6c, 0x6c,
      0x6f
    >>
  end

  test 'merge_body delete example' do
    options = [key: "Hello"]
    assert Memcachedx.Packet.Body.merge_body(options) == <<
      0x48, 0x65, 0x6c, 0x6c,
      0x6f
    >>
  end

  test 'merge_body incr/decr example' do
    options = [delta: 0x0000000000000001, initial: 0x0000000000000000, expiration: 0x00000e10, key: "counter"]
    assert Memcachedx.Packet.Body.merge_body(options) == <<
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x01,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x0e, 0x10,
      0x63, 0x6f, 0x75, 0x6e,
      0x74, 0x65, 0x72
    >>
  end
end
