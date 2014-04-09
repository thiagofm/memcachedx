defmodule Memcachedx.Packet.Body do
  def flags(flags) do
    flags
  end

  def expiry(expiry) do
    expiry
  end

  def delta(delta) do
    delta
  end

  def initial(initial) do
    initial
  end

  def expiration(expiration) do
    expiration
  end

  def key(key) do
    key
  end

  def value(value) do
    value
  end

  @doc """
  Builds a body
  """
  def build(opcode, options) do
    case opcode do
      opcode when opcode in [:get, :getkq] -> << options[:key] :: binary >>
      opcode when opcode in [:set, :setq, :add, :addq, :replace, :replaceq] ->
        <<
          options[:flags] :: [size(4), unit(8)],
          options[:expiry] :: [size(4), unit(8)],
          options[:key] :: binary,
          options[:value] :: binary
        >>
    end
  end
end
