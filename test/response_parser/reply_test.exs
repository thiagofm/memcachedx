defmodule ResponseParser.ReplyTest do
  use ExUnit.Case

  test "parses when key is stored" do
    assert ResponseParser.Reply.parse("STORED\r\n") == :stored
  end

  test "parses when key isn't stored" do
    assert ResponseParser.Reply.parse("NOT_STORED\r\n") == :not_stored
  end

  test "parses when key has already been modified when ran cas command" do
    assert ResponseParser.Reply.parse("EXISTS\r\n") == :exists
  end

  test "parses when key didn't exist when ran cas command" do
    assert ResponseParser.Reply.parse("NOT_FOUND\r\n") == :not_found
  end

  test "raises error if server output is unknown" do
    assert_raise ArgumentError, fn ->
      ResponseParser.Reply.parse("Foo\r\n")
    end
  end
end

