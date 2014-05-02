defmodule Memcachedx.Packet.Response.HeaderTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Response.Header, as: Header

  test 'opcode' do
    assert Header.opcode(0) == :get
  end
end
