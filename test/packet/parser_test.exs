defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Parser, as: Parser

  test 'response add' do
    assert Parser.response([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == {:ok, [opcode: :add, extra_length: 0, cas: 1]}
  end
end
