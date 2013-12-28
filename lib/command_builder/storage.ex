defmodule CommandBuilder.Storage do
  @moduledoc """
  ## Usage
  See CommandBuilder module docs

  ## Storage commands specification
  (spec taken from https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

      First, the client sends a command line which looks like this:

      <command name> <key> <flags> <exptime> <bytes> [noreply]\\r\\n
      cas <key> <flags> <exptime> <bytes> <cas unique> [noreply]\\r\\n

      - <command name> is "set", "add", "replace", "append" or "prepend"

        "set" means "store this data".

        "add" means "store this data, but only if the server *doesn't* already
        hold data for this key".

        "replace" means "store this data, but only if the server *does*
        already hold data for this key".

        "append" means "add this data to an existing key after existing data".

        "prepend" means "add this data to an existing key before existing data".

        The append and prepend commands do not accept flags or exptime.
        They update existing data portions, and ignore new flag and exptime
        settings.

        "cas" is a check and set operation which means "store this data but
        only if no one else has updated since I last fetched it."

      - <key> is the key under which the client asks to store the data

      - <flags> is an arbitrary 16-bit unsigned integer (written out in
        decimal) that the server stores along with the data and sends back
        when the item is retrieved. Clients may use this as a bit field to
        store data-specific information; this field is opaque to the server.
        Note that in memcached 1.2.1 and higher, flags may be 32-bits, instead
        of 16, but you might want to restrict yourself to 16 bits for
        compatibility with older versions.

      - <exptime> is expiration time. If it's 0, the item never expires
        (although it may be deleted from the cache to make place for other
        items). If it's non-zero (either Unix time or offset in seconds from
        current time), it is guaranteed that clients will not be able to
        retrieve this item after the expiration time arrives (measured by
        server time).

      - <bytes> is the number of bytes in the data block to follow, *not*
        including the delimiting \\r\\n. <bytes> may be zero (in which case
        it's followed by an empty data block).

      - <cas unique> is a unique 64-bit value of an existing entry.
        Clients should use the value returned from the "gets" command
        when issuing "cas" updates.

      - "noreply" optional parameter instructs the server to not send the
        reply.  NOTE: if the request line is malformed, the server can't
        parse "noreply" option reliably.  In this case it may send the error
        to the client, and not reading it on the client side will break
        things.  Client should construct only valid requests.

      After this line, the client sends the data block:

      <data block>\\r\\n

      - <data block> is a chunk of arbitrary 8-bit data of length <bytes>
        from the previous line.
  """

  @doc """
  Builds the storage commands append or prepend
  """
  def storage_command(command_name, key, bytes, data) when (command_name == :append or command_name == :prepend) do
    [
      "#{command_name} #{key} #{bytes}\r\n",
      "#{data}\r\n"
    ]
  end

  def storage_command(command_name, key, bytes, data, no_reply) when (no_reply == true and command_name == :append or command_name == :prepend) do
    [
      "#{command_name} #{key} #{bytes} [noreply]\r\n",
      "#{data}\r\n"
    ]
  end

  @doc """
  Builds the storage commands for CAS(check and set). The CAS operation checks if the record
  exists and only if nobody updated it since I fetched it

  The cas_unique flag is the value returned by the "gets" command.
  """
  def storage_command(command_name, key, bytes, data, cas_unique, flags, exptime) when (command_name == :cas) do
    [
      "#{command_name} #{key} #{flags} #{exptime} #{bytes} #{cas_unique}\r\n",
      "#{data}\r\n"
    ]
  end

  def storage_command(command_name, key, bytes, data, no_reply, cas_unique, flags, exptime) when (no_reply == true) do
    [
      "#{command_name} #{key} #{flags} #{exptime} #{bytes} #{cas_unique} [noreply]\r\n",
      "#{data}\r\n"
    ]
  end

  @doc """
  Builds the storage commands set, add or replace
  """
  def storage_command(command_name, key, bytes, data, flags, exptime) do
    [
      "#{command_name} #{key} #{flags} #{exptime} #{bytes}\r\n",
      "#{data}\r\n"
    ]
  end

  def storage_command(command_name, key, bytes, data, no_reply, flags, exptime) when (no_reply == true) do
    [
      "#{command_name} #{key} #{flags} #{exptime} #{bytes} [noreply]\r\n",
      "#{data}\r\n"
    ]
  end
end
