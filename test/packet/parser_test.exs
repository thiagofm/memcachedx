defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Parser, as: Parser

  test 'response add' do
    assert Parser.response([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == {:ok, [cas: 1, opcode: :add]}
  end

  test 'status ok' do
    assert Parser.status([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :ok
  end

  test 'status error' do
    assert Parser.status([129, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :error
  end

  test :total_body do
    assert Parser.total_body([
      0,0,0,0,
      0,0,0,0,
      0,0,0,0
    ], []) == []

    assert Parser.total_body([
      0,0,0,0,
      0,0,0,0,
      0,0,0,1
    ], []) == [total_body: 1]
  end

  test :body_parser do
    assert Parser.body_parser(
      [0, 0, 0, 0, 0, 0, 0, 3] , [total_body: 8, opcode: :incr]
    ) == [value: <<0,0,0,0,0,0,0,3>>]
  end

  test :body do
    assert Parser.body(
      [129, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
   0, 0, 0, 0, 0, 3], [total_body: 8, opcode: :incr]
    )
  end

  test :extra_vars_for do
    assert Parser.extra_vars_for(:incr) == [:value]
    assert Parser.extra_vars_for(:decr) == [:value]
  end

  test :opcode do
    assert Parser.opcode([0, 0x01], []) == [opcode: :set]
    assert Parser.opcode([0, 0x16], []) == [opcode: :decrq]
  end
end
