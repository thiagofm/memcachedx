defmodule CommandBuilderTest do
  use ExUnit.Case

  test :opcode do
    {:ok, result} = Memcachedx.CommandBuilder.opcode(:get) 
    assert result == <<0x00>>
  end
end
