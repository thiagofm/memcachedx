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
  Builds a binary request for a get

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode == :get do
    options = Options.initialize_vars(options)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for an add, set or replace

  Request:

  MUST have extras.
  MUST have key.
  MAY have value.
  """
  def request([opcode, options]) when opcode in [:add, :set, :replace] do
    vars = [:flags, :expiry]
    options = Options.initialize_vars(options, vars)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a delete

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:delete] do
    options = Options.initialize_vars(options)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a incr/decr

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:incr, :decr] do
    vars = [:delta, :initial, :expiration]
    options = Options.initialize_vars(options, vars)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a quit

  Request:

  MUST NOT have extras.
  MUST NOT have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:quit] do
    options = Options.initialize_vars(options)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a flush

  Request:

  MAY have extras.
  MUST NOT have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:flush] do
    vars = [:expiration]
    options = Options.initialize_vars(options, vars)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a noop

  Request:

  MUST NOT have extras.
  MUST NOT have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:noop] do
    options = Options.initialize_vars(options)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a version

  Request:

  MUST NOT have extras.
  MUST NOT have key.
  MUST NOT have value.
  """
  def request([opcode, options]) when opcode in [:version] do
    options = Options.initialize_vars(options)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end

  @doc """
  Builds a binary request for a append and prepend

  Request:

  MUST NOT have extras.
  MUST have key.
  MUST have value.
  """
  def request([opcode, options]) when opcode in [:append, :prepend] do
    options = Options.initialize_vars(options)

    Header.merge_header(opcode, options) <> Body.merge_body(options)
  end
end
