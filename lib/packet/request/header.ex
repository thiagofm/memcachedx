defmodule Memcachedx.Packet.Request.Header do
  @moduledoc """
  Builds up the header of a packet to be sent to talk with the memcached server.
  """

  def magic(value) do
    case value do
      :request -> 0x80
      :response -> 0x81
    end
  end

  def opcode(opcode) do
    case opcode do
      :get -> 0x00
      :set -> 0x01
      :add -> 0x02
      :replace -> 0x03
      :delete -> 0x04
      :incr -> 0x05
      :decr -> 0x06
      :quit -> 0x07
      :flush -> 0x08
      :noop -> 0x0A
      :version -> 0x0B
      :getkq -> 0x0D
      :append -> 0x0E
      :prepend -> 0x0F
      :stat -> 0x10
      :setq -> 0x11
      :addq -> 0x12
      :replaceq -> 0x13
      :deleteq -> 0x14
      :incrq -> 0x15
      :decrq -> 0x16
    end
  end

  def key_length(key) do
    Kernel.byte_size(key)
  end

  def extra_length(opcode) do
    case opcode do
      opcode when opcode in [:noop, :version, :append,
        :prepend, :stat, :delete, :deleteq, :get, :getkq, :quit] -> 0
      opcode when opcode in [:flush] -> 4
      opcode when opcode in [:set, :setq, :add, :addq, :replace, :replaceq] -> 8
      opcode when opcode in [:incr, :incrq, :decr, :decrq] -> 20
      true -> raise Error
    end
  end

  def data_type do
    0
  end

  def reserved do
    0
  end

  def total_body_length(extras, key, 0) do
    extras + key_length(key) + 0
  end

  def total_body_length(extras, key, value) do
    extras + key_length(key) + key_length(value)
  end

  def opaque(opaque) do
    opaque
  end

  def cas(cas) do
    cas
  end

  @doc """
  Merges the whole header into a binary request

  ### Example
  iex> opcode = :get
  iex> options = [value: "", key: "Hello", extras: 0, cas: 0, opaque: 0]
  iex> Memcachedx.Packet.Request.Header.merge_req(opcode, options)
  <<
      0x80, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00
  >>
  """
  def merge_req(opcode, options) do
    <<
      magic(:request)                                     ,
      opcode(opcode)                                      ,
      key_length(options[:key])                :: [size(2), unit(8)],
      extra_length(opcode)                                ,
      data_type                                           ,
      reserved                       :: [size(2), unit(8)],
      total_body_length(extra_length(opcode), options[:key], options[:value]):: [size(4), unit(8)],
      opaque(options[:opaque])                 :: [size(4), unit(8)],
      cas(options[:cas])                       :: [size(8), unit(8)],
    >>
  end
end
