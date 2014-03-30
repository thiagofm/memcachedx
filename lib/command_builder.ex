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

  def opcode(key) do
    HashDict.get(HashDict.new([
      get: <<0x00>>,
      set: <<0x01>>,
      add: <<0x02>>,
      replace: <<0x03>>,
      delete: <<0x04>>,
      incr: <<0x05>>,
      decr: <<0x06>>,
      flush: <<0x08>>,
      noop: <<0x0A>>,
      version: <<0x0B>>,
      getkq: <<0x0D>>,
      append: <<0x0E>>,
      prepend: <<0x0F>>,
      stat: <<0x10>>,
      setq: <<0x11>>,
      addq: <<0x12>>,
      replaceq: <<0x13>>,
      deleteq: <<0x14>>,
      incrq: <<0x15>>,
      decrq: <<0x16>>,
      auth_negotiation: <<0x20>>,
      auth_request: <<0x21>>,
      auth_continue: <<0x22>>,
      touch: <<0x1C>>,
    ]), key)
  end
end
