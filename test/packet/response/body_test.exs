defmodule Memcachedx.Packet.Response.BodyTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Response.Body, as: Body

  test :body_parser do
    assert Body.body_parser(
      [0, 0, 0, 0, 0, 0, 0, 3] , [total_body: 8, opcode: :incr]
    ) == [value: <<0,0,0,0,0,0,0,3>>]
  end

  test :body do
    assert Body.body(
      [129, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
   0, 0, 0, 0, 0, 3], [total_body: 8, opcode: :incr]
    )
  end

  test :extra_vars_for do
    assert Body.extra_vars_for(:incr) == [:value]
    assert Body.extra_vars_for(:decr) == [:value]
  end
end
