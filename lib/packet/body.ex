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

  @doc """
  Merges all body related options in the order that is expected from the memcached binary protocol
  """
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
end
