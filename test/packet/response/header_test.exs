defmodule Memcachedx.Packet.Response.HeaderTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Response.Header, as: Header

  test 'status ok' do
    assert Header.status([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :ok
  end

  test 'status error' do
    assert Header.status([129, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :error
  end

  test :total_body do
    assert Header.total_body([
      0,0,0,0,
      0,0,0,0,
      0,0,0,0
    ], []) == []

    assert Header.total_body([
      0,0,0,0,
      0,0,0,0,
      0,0,0,1
    ], []) == [total_body: 1]
  end

  test :opcode do
    assert Header.opcode([0, 0x01], []) == [opcode: :set]
    assert Header.opcode([0, 0x16], []) == [opcode: :decrq]
  end
end
