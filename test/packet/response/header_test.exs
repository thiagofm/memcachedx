defmodule Memcachedx.Packet.Response.HeaderTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Response.Header, as: Header

  test 'status ok' do
    assert Header.status([129, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]) == :ok
  end

  test 'status error' do
    assert Header.status([
      129, 2, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 1]) == :error
  end

  test :opcode do
    assert Header.opcode([0, 0x01], []) == [opcode: :set]
    assert Header.opcode([0, 0x16], []) == [opcode: :decrq]
  end

  test :extra_length do
    assert Header.extra_length([
      0, 0, 0, 0,
      0x04],[]) == [extra_length: 4]
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

  test :cas do
    assert Header.cas([
      0,0,0,0,
      0,0,0,0,
      0,0,0,0,
      0,0,0,0,
      0,0,0,0,
      0,0,0,1
    ], []) == [cas: 1]
  end

  test :merge_res do
    assert Header.merge_res([
      0x81,0,0,0,
      0,0,0,0x01,
      0,0,0,0x09,
      0,0,0,0,
      0,0,0,0,
      0,0,0,0,
      0x4e, 0x6f, 0x74, 0x20,
      0x66, 0x6f, 0x75, 0x6e,
      0x64
    ], []) == [opcode: :get, extra_length: 0, total_body: 9, cas: 0]
  end
end
