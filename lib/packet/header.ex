defmodule Memcachedx.Packet.Header do
  @moduledoc """
  The binary protocol hexcodes of the packet's header.

  ## Example

      Memcachedx.Packet.Header.opcode(:get)

  Returns:

      <<0x00>>

  Which is the hexcode necessary to build up the packet to communicate with memcached.
  """

  @doc """
  The header's magic value

  ## Example

      Memcachedx.Packet.Header.magic(:request)

  Returns:

      <<0x80>>
  """
  def magic(value) do
    case value do
      :request -> <<0x80>>
      :response -> <<0x81>>
    end
  end

  @doc """
  The header's opcodes

  ## Example

      Memcachedx.Packet.Header.opcode(:get)

  Returns:

      <<0x80>>
  """
  def opcode(opcode) do
    case opcode do
      :get -> <<0x00>>
      :set -> <<0x01>>
      :add -> <<0x02>>
      :replace -> <<0x03>>
      :delete -> <<0x04>>
      :incr -> <<0x05>>
      :decr -> <<0x06>>
      :flush -> <<0x08>>
      :noop -> <<0x0A>>
      :version -> <<0x0B>>
      :getkq -> <<0x0D>>
      :append -> <<0x0E>>
      :prepend -> <<0x0F>>
      :stat -> <<0x10>>
      :setq -> <<0x11>>
      :addq -> <<0x12>>
      :replaceq -> <<0x13>>
      :deleteq -> <<0x14>>
      :incrq -> <<0x15>>
      :decrq -> <<0x16>>
    end
  end

  @doc """
  The header's key length

  ## Example

      Memcachedx.Packet.Header.key_length('xpto')

  Returns:

      4
  """
  def key_length(key) do
    Kernel.byte_size(key)
  end

  @doc """
  The header's extra length

  ## Example

      Memcachedx.Packet.Header.extra_length(:get)

  Returns:

      4

  The returned value represents the amount of byte flags needed
  """
  def extra_length(opcode) do
    case opcode do
      opcode when opcode in [:noop, :version, :append, :prepend, :stat, :delete, :deleteq] -> 0
      opcode when opcode in [:get, :getkq, :flush] -> 4
      opcode when opcode in [:set, :setq, :add, :addq, :replace, :replaceq] -> 8
      opcode when opcode in [:incr, :incrq, :decr, :decrq] -> 20
    end
  end

  @doc """
  The header's data type

  ## Example

      Memcachedx.Packet.Header.data_type

  Returns:

      0

  """
  def data_type do
    0
  end

  @doc """
  The header's reserved

  ## Example

      Memcachedx.Packet.Header.reserved

  Returns:

      0

  """
  def reserved do
    0
  end

  @doc """
  The header's total body length

  ## Example

      Memcachedx.Packet.Header.total_body_length(0, "hello", "")

  Returns:

      5

  """
  def total_body_length(extras, key, value) do
    extras + key_length(key) + key_length(value)
  end

  @doc """
  The header's opaque

  ### Example

      Memcached.Packet.Header.opaque(1)

  Returns:

      1

  """
  def opaque(opaque) do
    opaque
  end
end
