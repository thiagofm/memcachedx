defmodule ResponseParser.StorageCommandReply do
  @moduledoc """
  ## Usage

  ResponseParser.StorageCommandReply.parse("CLIENT_ERROR random_error\r\n") # {:error, "random_error"}

  ## Storage command reply specification
  (spec taken from https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

  After sending the command line and the data blockm the client awaits
  the reply, which may be:

  - "STORED\r\n", to indicate success.

  - "NOT_STORED\r\n" to indicate the data was not stored, but not
  because of an error. This normally means that the
  condition for an "add" or a "replace" command wasn't met.

  - "EXISTS\r\n" to indicate that the item you are trying to store with
  a "cas" command has been modified since you last fetched it.

  - "NOT_FOUND\r\n" to indicate that the item you are trying to store
  with a "cas" command did not exist.
  """

  @doc """
  Parses a storage command reply from the server
  """
  def parse(server_reply) do
    cond do
      server_reply =~ %r/^STORED\r\n/ ->
        :stored
      server_reply =~ %r/^NOT_STORED\r\n/ ->
        :not_stored
      server_reply =~ %r/^EXISTS\r\n/ ->
        :exists
      server_reply =~ %r/^NOT_FOUND\r\n/ ->
        :not_found
      true ->
        raise(ArgumentError, message: "Unknown output from server.")
    end
  end
end
