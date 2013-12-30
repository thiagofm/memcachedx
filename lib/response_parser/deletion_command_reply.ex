defmodule Memcachedx.ResponseParser.DeletionCommandReply do
  @moduledoc """
  ## Deletion command reply specification
  The command "delete" allows for explicit deletion of items:

  delete <key> [noreply]\\r\\n

  - <key> is the key of the item the client wishes the server to delete

  - "noreply" optional parameter instructs the server to not send the
    reply.  See the note in Storage commands regarding malformed
    requests.

  The response line to this command can be one of:

  - "DELETED\\r\\n" to indicate success

  - "NOT_FOUND\\r\\n" to indicate that the item with this key was not
    found.

  See the "flush_all" command below for immediate invalidation
  of all existing items.

  """

  def parse(server_reply) do
    cond do
      server_reply =~ %r/^DELETED\r\n/ ->
        :deleted
      server_reply =~ %r/^NOT_FOUND\r\n/ ->
        :not_found
      true ->
        raise(ArgumentError, message: "Unknown output from server.")
    end
  end
end
