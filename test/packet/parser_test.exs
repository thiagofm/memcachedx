defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case

  test 'response add' do
    assert Memcachedx.Packet.Parser.response([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == {:ok, [cas: 1, opcode: :add]}
  end

  test 'status ok' do
    assert Memcachedx.Packet.Parser.status([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :ok
  end

  test 'status error' do
    assert Memcachedx.Packet.Parser.status([129, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :error
  end

  test :total_body do
    assert Memcachedx.Packet.Parser.total_body([
      0,0,0,0,
      0,0,0,0,
      0,0,0,0
    ], []) == []

    assert Memcachedx.Packet.Parser.total_body([
      0,0,0,0,
      0,0,0,0,
      0,0,0,1
    ], []) == [total_body: 1]
  end

  test :extra_vars_for do
    assert Memcachedx.Packet.Parser.extra_vars_for(:incr) == [:value]
    assert Memcachedx.Packet.Parser.extra_vars_for(:decr) == [:value]
  end

  test :opcode do
    assert Memcachedx.Packet.Parser.opcode([0, 0x01], []) == [opcode: :set]
    assert Memcachedx.Packet.Parser.opcode([0, 0x16], []) == [opcode: :decrq]
  end
end
