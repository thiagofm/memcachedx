defmodule ResponseParser.RetrievalCommandReply do
  @moduledoc """
  ## Retrieval command reply specification
  (spec taken from https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

  The retrieval commands "get" and "gets" operates like this:

  get <key>*\r\n
  gets <key>*\r\n

  - <key>* means one or more key strings separated by whitespace.

  After this command, the client expects zero or more items, each of
  which is received as a text line followed by a data block. After all
  the items have been transmitted, the server sends the string

  "END\r\n"

  to indicate the end of response.

  Each item sent by the server looks like this:

  VALUE <key> <flags> <bytes> [<cas unique>]\r\n
  <data block>\r\n

  - <key> is the key for the item being sent

  - <flags> is the flags value set by the storage command

  - <bytes> is the length of the data block to follow, *not* including
    its delimiting \r\n

  - <cas unique> is a unique 64-bit integer that uniquely identifies
    this specific item.

  - <data block> is the data for this item.

  If some of the keys appearing in a retrieval request are not sent back
  by the server in the item list this means that the server does not
  hold items with such keys (because they were never stored, or stored
  but deleted to make space for more items, or expired, or explicitly
  deleted by a client).
  """

  @doc """
    Parses a list with 2 elements, one is composed of informations
    about the stored memcached key and the other is the stored data itself.
  """
  def parse(server_response) when is_list(server_response) do
    # Second line of response
    data_match = Regex.run(%r/^(.*)\r\n$/, Enum.fetch!(server_response, 1))

    cond do
      default_match = Regex.run(%r/^VALUE ([^ ]*) ([^ ]*) ([^ ]*)\r\n/, Enum.fetch!(server_response, 0)) ->
        [
          key: Enum.fetch!(default_match, 1),
          flags: Enum.fetch!(default_match, 2),
          bytes: Enum.fetch!(default_match, 3),
          cas_unique: nil,
          data: Enum.fetch!(default_match, 1)
        ]
      cas_match = Regex.run(%r/^VALUE ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*)\r\n/, Enum.fetch!(server_response, 0)) ->
        [
          key: Enum.fetch!(cas_match, 1),
          flags: Enum.fetch!(cas_match, 2),
          bytes: Enum.fetch!(cas_match, 3),
          cas_unique: Enum.fetch!(cas_match, 4),
          data: Enum.fetch!(cas_match, 1)
        ]
      true ->
        raise(ArgumentError, message: "Unknown output from server.")
    end
  end
end
