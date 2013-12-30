defmodule Memcachedx.CommandBuilder.Deletion do
  @moduledoc """
  ## Deletion command specification
  (spec taken from https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

  The command "delete" allows for explicit deletion of items:

  delete <key> [noreply]\r\n

  - <key> is the key of the item the client wishes the server to delete

  - "noreply" optional parameter instructs the server to not send the
    reply.  See the note in Storage commands regarding malformed
    requests.

  The response line to this command can be one of:

  - "DELETED\r\n" to indicate success

  - "NOT_FOUND\r\n" to indicate that the item with this key was not
    found.

  See the "flush_all" command below for immediate invalidation
  of all existing items.
  """

  def deletion_command(:delete, key, no_reply) do
    [
      "delete #{key} [no_reply]\r\n"
    ]
  end

  def deletion_command(:delete, key) do
    [
      "delete #{key}\r\n"
    ]
  end
end
