defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Parser, as: Parser

  test 'response add' do
    assert Parser.response([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == {:ok, [cas: 1, opcode: :add]}
  end
end
