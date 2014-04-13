defmodule Memcachedx.Packet.Builder do
  @moduledoc """
  Builds a protocol request

  ### Example
  iex> Memcachedx.Packet.Builder.request([:get, [key: "Hello", cas: 0]])
  <<
    0x80, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x48, 0x65, 0x6c, 0x6c,
    0x6f
  >>

  Which is the binary needed to do the desired request to memcached.
  """

  alias Memcachedx.Packet.Header, as: Header
  alias Memcachedx.Packet.Body, as: Body
  alias Memcachedx.Utils.Options, as: Options

  @doc """
  Returns the necessary extra vars for the defined opcode
  """
  def extra_vars_for(opcode) do
    case opcode do
      opcode when opcode in [:get, :delete, :quit, :noop, :version, :append, :prepend, :stat] -> []
      opcode when opcode in [:add, :set, :replace] -> [:flags, :expiry]
      opcode when opcode in [:flush] -> [:expiration]
      opcode when opcode in [:incr, :decr] -> [:delta, :initial, :expiration]
      true -> raise Error
    end
  end

  @doc """
  Builds a binary request for a opcode
  """
  def request([opcode, options]) do
    extra_vars = extra_vars_for(opcode)
    options = Options.initialize_vars(options, extra_vars)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end
end
