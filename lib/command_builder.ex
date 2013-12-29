defmodule Memcachedx.CommandBuilder do
  @moduledoc """
  Builds a list of commands that needs to be executed subsequently in order to interact with
  memcached with the given parameters.

  ## Example
  Setting key foo with 5 bytes with the bar value and don't receive any response from the
  server (no reply option) flagged as 0 and with 86400 to expire:

      Memcachedx.CommandBuilder.storage_command(:set, "foo", "5", "bar", true, "0", "86400")

  Returns:

      ["set foo 0 86400 5 [noreply]\\r\\n", "bar\\r\\n"]

  Which is the commands that needs to be run sequently in memcached to do the desired action.
  """
end
