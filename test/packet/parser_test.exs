defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Parser, as: Parser

  test 'body - value not found' do
    assert Parser.body(
    [opcode: :get, extras_length: 0, key_length: 0, total_body_length: 9, cas: 0], <<
      0x4e, 0x6f, 0x74, 0x20,
      0x66, 0x6f, 0x75, 0x6e,
      0x64
    >>) == [opcode: :get, extras_length: 0, key_length: 0, total_body_length: 9, cas: 0, value: "Not found"]
  end

  test 'body with flags - key and value found' do
    assert Parser.body(
    [opcode: :get, extras_length: 4, key_length: 5, total_body_length: 9, cas: 0], <<
      0xde, 0xad, 0xbe, 0xef,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>) == [opcode: :get, extras_length: 4, key_length: 5, total_body_length: 9, cas: 0, extras: <<0xde, 0xad, 0xbe, 0xef>>, key: "Hello", value: "World"]
  end

  test 'body - key and value found' do
    assert Parser.body(
    [opcode: :get, extras_length: 0, key_length: 5, total_body_length: 9, cas: 0], <<
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>) == [opcode: :get, extras_length: 0, key_length: 5, total_body_length: 9, cas: 0, key: "Hello", value: "World"]
  end

  test :res do
    assert Parser.res_header(
      <<
        129, 2, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 1
      >>) == {
        :ok,
        [
          opcode: :add,
          key_length: 0,
          extras_length: 0,
          total_body_length: 0,
          opaque: 0,
          cas: 1
        ]
      }
  end

  test 'response single' do
      assert Parser.response(<<129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1>>) == {:ok, [opcode: :add, key_length: 0, extra_length: 0, total_body: 0, cas: 1]}
  end

  test 'response multiple' do
    res = Parser.response(<<129, 16, 0, 3, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 105, 100, 54, 56, 49, 52, 50, 129, 16, 0, 6, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 117, 112, 116, 105, 109, 101, 50, 129, 16, 0, 4, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 116, 105, 109, 101, 49, 51, 57, 56, 48, 57, 56, 56, 56,
 55, 129, 16, 0, 7, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 118, 101, 114, 115, 105, 111, 110, 49, 46, 52, 46, 49, 51, 129, 16, 0, 8, 0, 0, 0, 0, 0, 0, 0,
 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108, 105, 98, 101, 118, 101, 110, 116, 50, 46, 48, 46, 49, 55, 45, 115, 116, 97, 98, 108, 101, 129, 16, 0, 12, 0, 0, 0, 0, 0, 0, 0, 14,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 111, 105, 110, 116, 101, 114, 95, 115, 105, 122, 101, 54, 52, 129, 16, 0, 11, 0, 0, 0, 0, 0, 0, 0, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 114, 117, 115, 97, 103, 101, 95, 117, 115, 101, 114, 48, 46, 48, 48, 49, 51, 49, 57, 129, 16, 0, 13, 0, 0, 0, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 114, 117,
 115, 97, 103, 101, 95, 115, 121, 115, 116, 101, 109, 48, 46, 48, 48, 49, 55, 56, 57, 129, 16, 0, 16, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 117, 114,
 114, 95, 99, 111, 110, 110, 101, 99, 116, 105, 111, 110, 115, 49, 48, 129, 16, 0, 17, 0, 0, 0, 0, 0, 0, 0, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 116, 111, 116, 97, 108, 95,
 99, 111, 110, 110, 101, 99, 116, 105, 111, 110, 115, 49, 49, 129, 16, 0, 21, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 111, 110, 110, 101, 99, 116, 105,
 111, 110, 95, 115, 116, 114, 117, 99, 116, 117, 114, 101, 115, 49, 49, 129, 16, 0, 12, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 114, 101, 115, 101, 114, 118,
 101, 100, 95, 102, 100, 115, 50, 48, 129, 16, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 109, 100, 95, 103, 101, 116, 48, 129, 16, 0, 7, 0, 0, 0, 0,
 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 109, 100, 95, 115, 101, 116, 48, 129, 16, 0, 9, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 109, 100,
 95, 102, 108, 117, 115, 104, 48, 129, 16, 0, 9, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 109, 100, 95, 116, 111, 117, 99, 104, 48, 129, 16, 0, 8, 0, 0,
 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 103, 101, 116, 95, 104, 105, 116, 115, 48, 129, 16, 0, 10, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 103, 101, 116, 95, 109, 105, 115, 115, 101, 115, 48, 129, 16, 0, 13, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 101, 108, 101, 116, 101, 95, 109, 105,
 115, 115, 101, 115, 48, 129, 16, 0, 11, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 101, 108, 101, 116, 101, 95, 104, 105, 116, 115, 48, 129, 16, 0, 11, 0,
 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 105, 110, 99, 114, 95, 109, 105, 115, 115, 101, 115, 48, 129, 16, 0, 9, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 105, 110, 99, 114, 95, 104, 105, 116, 115, 48, 129, 16, 0, 11, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 101, 99, 114, 95, 109, 105, 115,
 115, 101, 115, 48, 129, 16, 0, 9, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 101, 99, 114, 95, 104, 105, 116, 115, 48, 129, 16, 0, 10, 0, 0, 0, 0, 0, 0,
 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 97, 115, 95, 109, 105, 115, 115, 101, 115, 48, 129, 16, 0, 8, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 97,
 115, 95, 104, 105, 116, 115, 48, 129, 16, 0, 10, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 97, 115, 95, 98, 97, 100, 118, 97, 108, 48, 129, 16, 0, 10, 0,
 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 116, 111, 117, 99, 104, 95, 104, 105, 116, 115, 48, 129, 16, 0, 12, 0, 0, 0, 0, 0, 0, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 116, 111, 117, 99, 104, 95, 109, 105, 115, 115, 101, 115, 48, 129, 16, 0, 9, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 117, 116, 104, 95, 99,
 109, 100, 115, 48, 129, 16, 0, 11, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 117, 116, 104, 95, 101, 114, 114, 111, 114, 115, 48, 129, 16, 0, 10, 0, 0, 0,
 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 121, 116, 101, 115, 95, 114, 101, 97, 100, 50, 52, 129, 16, 0, 13, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 98, 121, 116, 101, 115, 95, 119, 114, 105, 116, 116, 101, 110, 48, 129, 16, 0, 14, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108, 105, 109, 105, 116,
 95, 109, 97, 120, 98, 121, 116, 101, 115, 54, 55, 49, 48, 56, 56, 54, 52, 129, 16, 0, 15, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 99, 99, 101, 112, 116,
 105, 110, 103, 95, 99, 111, 110, 110, 115, 49, 129, 16, 0, 19, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108, 105, 115, 116, 101, 110, 95, 100, 105, 115, 97,
 98, 108, 101, 100, 95, 110, 117, 109, 48, 129, 16, 0, 7, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 116, 104, 114, 101, 97, 100, 115, 52, 129, 16, 0, 11, 0, 0,
 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 99, 111, 110, 110, 95, 121, 105, 101, 108, 100, 115, 48, 129, 16, 0, 16, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 104, 97, 115, 104, 95, 112, 111, 119, 101, 114, 95, 108, 101, 118, 101, 108, 49, 54, 129, 16, 0, 10, 0, 0, 0, 0>>)
    assert Enum.count(res) == 39
  end
end
