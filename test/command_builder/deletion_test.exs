defmodule Memcachedx.CommandBuilder.DeletionTest do
  use ExUnit.Case

  test :deletion_command do
    assert Memcachedx.CommandBuilder.Deletion.deletion_command(:delete, "foo") == ["delete foo\r\n"]
  end

  test "deletion_command with no reply" do
    assert Memcachedx.CommandBuilder.Deletion.deletion_command(:delete, "foo", true) == ["delete foo [no_reply]\r\n"]
  end
end
