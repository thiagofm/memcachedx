defmodule Memcachedx.ResponseParser.RetrievalCommandReplyTest do
  use ExUnit.Case

  test "default parse" do
    info = "VALUE foo 0 5\r\n"
    data = "bar\r\n"

    assert Memcachedx.ResponseParser.RetrievalCommandReply.parse([info, data]) == [key: "foo", flags: "0", bytes: "5", cas_unique: nil, data: "foo"]
  end

  test "parse when response has cas_unique" do
    info = "VALUE foo 0 5 64-bit_value\r\n"
    data = "bar\r\n"

    assert Memcachedx.ResponseParser.RetrievalCommandReply.parse([info, data]) == [key: "foo", flags: "0", bytes: "5", cas_unique: "64-bit_value", data: "foo"]
  end

  test "raises error if server output is unknown" do
    assert_raise ArgumentError, fn ->
      Memcachedx.ResponseParser.Error.parse("Foo\r\n")
    end
  end
end

