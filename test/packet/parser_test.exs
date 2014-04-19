defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Parser, as: Parser

  test 'response add' do
    assert Parser.response([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == {:ok, [cas: 1, opcode: :add]}
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
end
