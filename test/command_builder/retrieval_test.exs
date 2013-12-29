defmodule CommandBuilder.RetrievalTest do
  use ExUnit.Case

  test "get retrieve command single string" do
    assert CommandBuilder.Retrieval.retrieval_command(:get, "Foo") == ["get Foo\r\n"]
  end

  test "get retrieve command list" do
    assert CommandBuilder.Retrieval.retrieval_command(:get, ["Foo", "Bar"]) == ["get Foo Bar\r\n"]
  end

  test "gets retrieve command single string" do
    assert CommandBuilder.Retrieval.retrieval_command(:gets, "Foo") == ["gets Foo\r\n"]
  end

  test "gets retrieve command list" do
    assert CommandBuilder.Retrieval.retrieval_command(:gets, ["Foo", "Bar"]) == ["gets Foo Bar\r\n"]
  end
end
