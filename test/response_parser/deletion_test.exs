defmodule Memcachedx.ResponseParser.DeletionCommandReplyTest do
  use ExUnit.Case

  test "parse when deleted" do
    assert Memcachedx.ResponseParser.DeletionCommandReply.parse("DELETED\r\n") == :deleted
  end

  test "parse when not found" do
    assert Memcachedx.ResponseParser.DeletionCommandReply.parse("NOT_FOUND\r\n") == :not_found
  end

  test "raises error if server output is unknown" do
    assert_raise ArgumentError, fn ->
      Memcachedx.ResponseParser.Error.parse("Foo\r\n")
    end
  end
end
