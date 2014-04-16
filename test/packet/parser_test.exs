defmodule Memcachedx.Packet.ParserTest do
  use ExUnit.Case

  test 'response set' do
    assert Memcachedx.Packet.Parser.response([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == {:ok, [cas: 1]}
  end
end
