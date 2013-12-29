defmodule ResponseParser.ErrorTest do
  use ExUnit.Case

  test "parses command error" do
    assert ResponseParser.Error.parse("ERROR\r\n") == [error: [message: "The client sent a nonexistent command name.", type: :command]]
  end

  test "parses client error" do
    assert ResponseParser.Error.parse("CLIENT_ERROR Too much sugar\r\n") == [error: [message: "Too much sugar", type: :client]]
  end

  test "parses server error" do
    assert ResponseParser.Error.parse("SERVER_ERROR Too much caffeine\r\n") == [error: [message: "Too much caffeine", type: :server]]
  end

  test "raises error if server output is unknown" do
    assert_raise ArgumentError, fn ->
      ResponseParser.Error.parse("Foo\r\n")
    end
  end
end

