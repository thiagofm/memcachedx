defmodule CommandBuilder.Retrieval do
  @moduledoc """
  ## Usage
  See CommandBuilder module docs

  ## Retrieval commands specification
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
    Get command for multiple keys(list of strings)
  """
  def retrieval_command(command, items) when is_list(items) and (command == :get or command == :gets) do
    ["#{command} #{Enum.join(items, " ")}\r\n"]
  end

  @doc """
    Get command for a single key(string)
  """
  def retrieval_command(command, item) when command == :get or command == :gets do
    ["#{command} #{item}\r\n"]
  end
end
