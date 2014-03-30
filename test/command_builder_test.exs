defmodule CommandBuilderTest do
  use ExUnit.Case

  test :opcode do
    assert Memcachedx.CommandBuilder.opcode(:get) == <<0x00>>
  end
end
