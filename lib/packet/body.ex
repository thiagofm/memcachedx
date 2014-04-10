defmodule Memcachedx.Packet.Body do
  def flags(flags) do
    << flags :: [size(4), unit(8)] >>
  end

  def expiry(expiry) do
    << expiry :: [size(4), unit(8)] >>
  end

  def delta(delta) do
    << delta :: [size(8), unit(8)] >>
  end

  def initial(initial) do
    << initial :: [size(8), unit(8)] >>
  end

  def expiration(expiration) do
    << expiration :: [size(4), unit(8)] >>
  end

  def key(key) do
    << key :: binary >>
  end

  def value(value) do
    << value :: binary >>
  end

  @doc """
  Merges all body related options in the order that is expected from the memcached binary protocol

  ### Example
  iex> Memcachedx.Packet.Body.merge_body([key: "Hello"])
  <<
      0x48, 0x65, 0x6c, 0x6c,
      0x6f
  >>
  """
  def merge_body(options) do
    order = [:delta, :initial, :expiration, :flags, :expiry, :key, :value]

    Enum.reduce(order, <<>>, fn (item, acc) ->
      if Keyword.has_key?(options, item) do
        acc = acc <> case item do
          :delta -> delta(options[:delta])
          :initial -> initial(options[:initial])
          :expiration -> expiration(options[:expiration])
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
