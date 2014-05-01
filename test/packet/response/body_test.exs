defmodule Memcachedx.Packet.Response.BodyTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Response.Body, as: Body

  test 'body when value not found' do
    assert Body.parse(
    [opcode: :get, extras_length: 0, key_length: 0, total_body_length: 9], <<
      0x4e, 0x6f, 0x74, 0x20,
      0x66, 0x6f, 0x75, 0x6e,
      0x64
    >>) == [opcode: :get, extras_length: 0, key_length: 0, total_body_length: 9, key: "", value: "Not found"]
  end

  test 'body when no body' do
    assert Body.parse(
    [opcode: :get, extras_length: 0, key_length: 0, total_body_length: 0], <<
    >>) == [opcode: :get, extras_length: 0, key_length: 0, total_body_length: 0, key: "", value: ""]
  end

  test 'body when key and value found (getk)' do
    assert Body.parse(
    [opcode: :getk, extras_length: 4, key_length: 5, total_body_length: 9], <<
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>) == [opcode: :getk, extras_length: 4, key_length: 5, total_body_length: 9, key: "Hello", value: "World"]
  end

  test 'body when value found' do
    assert Body.parse(
    [opcode: :get, key_length: 0, extras_length: 0, total_body_length: 5, opaque: 0], <<
      87, 111, 114, 108,
      100
    >>) == [opcode: :get, key_length: 0, extras_length: 0, total_body_length: 5, opaque: 0, key: "", value: "World"]
  end
end
