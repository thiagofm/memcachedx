defmodule CommandBuilder.StorageTest do
  use ExUnit.Case

  test "set storage_command" do
    assert CommandBuilder.Storage.storage_command(:set, "foo", "5", "bar", "0", "86400") == ["set foo 0 86400 5\r\n", "bar\r\n"]
  end

  test "set storage_command with no reply" do
    assert CommandBuilder.Storage.storage_command(:set, "foo", "5", "bar", true, "0", "86400") == ["set foo 0 86400 5 [noreply]\r\n", "bar\r\n"]
  end

  test "add storage_command" do
    assert CommandBuilder.Storage.storage_command(:add, "foo", "5", "bar", "0", "86400") == ["add foo 0 86400 5\r\n", "bar\r\n"]
  end

  test "add storage_command with no reply" do
    assert CommandBuilder.Storage.storage_command(:add, "foo", "5", "bar", true, "0", "86400") == ["add foo 0 86400 5 [noreply]\r\n", "bar\r\n"]
  end

  test "replace storage_command" do
    assert CommandBuilder.Storage.storage_command(:replace, "foo", "5", "bar", "0", "86400") == ["replace foo 0 86400 5\r\n", "bar\r\n"]
  end

  test "replace storage_command with no reply" do
    assert CommandBuilder.Storage.storage_command(:replace, "foo", "5", "bar", true, "0", "86400") == ["replace foo 0 86400 5 [noreply]\r\n", "bar\r\n"]
  end

  test "append storage_command" do
    assert CommandBuilder.Storage.storage_command(:append, "foo", "5", "baz") == ["append foo 5\r\n", "baz\r\n"]
  end

  test "append storage_command with no reply" do
    assert CommandBuilder.Storage.storage_command(:append, "foo", "5", "baz", true) == ["append foo 5 [noreply]\r\n", "baz\r\n"]
  end

  test "prepend storage_command" do
    assert CommandBuilder.Storage.storage_command(:prepend, "foo", "5", "baz") == ["prepend foo 5\r\n", "baz\r\n"]
  end

  test "prepend storage_command with no reply" do
    assert CommandBuilder.Storage.storage_command(:prepend, "foo", "5", "baz", true) == ["prepend foo 5 [noreply]\r\n", "baz\r\n"]
  end

  test "cas storage_command" do
    assert CommandBuilder.Storage.storage_command(:cas, "foo", "5", "bar", "64-bit_value", "0", "86400") == ["cas foo 0 86400 5 64-bit_value\r\n", "bar\r\n"]
  end

  test "cas storage_command with no reply" do
    assert CommandBuilder.Storage.storage_command(:cas, "foo", "5", "bar", true, "64-bit_value", "0", "86400") == ["cas foo 0 86400 5 64-bit_value [noreply]\r\n", "bar\r\n"]
  end
end
