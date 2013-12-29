defmodule ResponseParser.Error do
  @moduledoc """
  ## Usage

  ResponseParser.Error.parse("CLIENT_ERROR random_error\r\n") # {:error, "random_error"}

  ## Error strings specification
  (spec taken from https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

  Each command sent by a client may be answered with an error string
  from the server. These error strings come in three types:

  - "ERROR\r\n"

    means the client sent a nonexistent command name.

  - "CLIENT_ERROR <error>\r\n"

    means some sort of client error in the input line, i.e. the input
    doesn't conform to the protocol in some way. <error> is a
    human-readable error string.

  - "SERVER_ERROR <error>\r\n"

    means some sort of server error prevents the server from carrying
    out the command. <error> is a human-readable error string. In cases
    of severe server errors, which make it impossible to continue
    serving the client (this shouldn't normally happen), the server will
    close the connection after sending the error line. This is the only
    case in which the server closes a connection to a client.


  In the descriptions of individual commands below, these error lines
  are not again specifically mentioned, but clients must allow for their
  possibility.
  """

  def parse(server_response) do
    cond do
      server_response =~ %r/ERROR\r\n/ ->
        [error: [message: "The client sent a nonexistent command name.", type: :command]]
      match = Regex.run(%r/CLIENT_ERROR (.*)\r\n/, server_response) ->
        [error: [message: Enum.fetch!(match, 1), type: :client]]
      match = Regex.run(%r/SERVER_ERROR (.*)\r\n/, server_response) ->
        [error: [message: Enum.fetch!(match, 1), type: :server]]
      true ->
        raise(ArgumentError, message: "Unknown output from server.")
    end
  end
end
