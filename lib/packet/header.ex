defmodule Memcachedx.Packet.Header do
  @moduledoc """
  The binary protocol hexcodes of the packet's header.

  ## Example
  Memcachedx.Packet.Header

      Memcachedx.Packet.Header.opcode(:get)

  Returns:

      <<0x00>>

  Which is the hexcode necessary to build up the packet to communicate with memcached.
  """

  @doc """
    The binary protocol opcodes
  """
  def opcode(key) do
    case key do
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
      :auth_negotiation -> <<0x20>>
      :auth_request -> <<0x21>>
      :auth_continue -> <<0x22>>
      :touch -> <<0x1C>>
    end
  end
end
