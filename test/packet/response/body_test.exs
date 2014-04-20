defmodule Memcachedx.Packet.Response.BodyTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Response.Body, as: Body

  test :body_parser do
    assert Body.body_parser(
      [0, 0, 0, 0, 0, 0, 0, 3] , [total_body: 8, extra_length: 0, opcode: :incr]
    ) == [value: <<0,0,0,0,0,0,0,3>>]
  end

  test 'merge_res incr' do
    assert Body.merge_res(
      [129, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
   0, 0, 0, 0, 0, 3], [total_body: 8, extra_length: 0, opcode: :incr]
    )
  end

  test 'merge_res get' do
    assert Body.merge_res([
      0x81,0,0,0,
      0,0,0,0x01,
      0,0,0,0x09,
      0,0,0,0,
      0,0,0,0,
      0,0,0,0,
      0x4e, 0x6f, 0x74, 0x20,
      0x66, 0x6f, 0x75, 0x6e,
      0x64
    ], [opcode: :get, extra_length: 0, total_body: 9, cas: 0]) == [opcode: :get, extra_length: 0, total_body: 9, cas: 0, value: "Not found"]
  end

  test 'merge_res get cas' do
    assert Body.merge_res([
      0x81,0,0,0,
      0x04,0,0,0,
      0,0,0,0x09,
      0,0,0,0,
      0,0,0,0,
      0,0,0,1,
      0xde, 0xad, 0xbe, 0xef,
      0x57, 0x6f, 0x72, 0x6c,
      0x64
    ], [opcode: :get, extra_length: 4, total_body: 9, flags: 0xdeadbeef]) == [opcode: :get, extra_length: 4, total_body: 9, cas: 0, value: "World"]
  end

  test :extra_vars_for do
    assert Body.extra_vars_for(:incr) == [:value]
    assert Body.extra_vars_for(:decr) == [:value]
  end
end
