defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def params(message) do
    Header.merge_res(message, []) |> Body.merge_res(message)
  end

  def response(message) do
    { Header.status(message), params(message)}
  end
end
