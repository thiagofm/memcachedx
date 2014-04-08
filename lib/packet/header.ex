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

      <<0x04>>

  The returned value represents the amount of byte flags needed
  """
  def extra_length(opcode) do
    case opcode do
      :noop -> 0
      :version -> 0
      :append -> 0
      :prepend -> 0
      :stat -> 0
      :delete -> 0
      :deleteq -> 0
      :get -> 4
      :getkq -> 4
      :flush -> 4
      :set -> 8
      :setq -> 8
      :add -> 8
      :addq -> 8
      :replace -> 8
      :replaceq -> 8
      :incr -> 20
      :incrq -> 20
      :decr -> 20
      :decrq -> 20
    end
  end
end
