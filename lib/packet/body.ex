defmodule Memcachedx.Packet.Body do
  def flags(flags) do
    << flags :: [size(4), unit(8)] >>
  end

  def expiry(expiry) do
    << expiry :: [size(4), unit(8)] >>
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
    << key :: binary >>
  end

  def value(value) do
    << value :: binary >>
  end

  def merge_body(options) do
    order = [:flags, :expiry, :key, :value]

    Enum.reduce(order, <<>>, fn (item, acc) ->
      if Keyword.has_key?(options, item) do
        acc = acc <> case item do
          :flags -> flags(options[:flags])
          :expiry -> expiry(options[:expiry])
          :key -> key(options[:key])
          :value -> value(options[:value])
          true -> <<>>
        end
      end
      acc
    end)
  end

  @doc """
  Builds a body request
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
