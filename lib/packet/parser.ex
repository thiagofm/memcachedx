defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def params(message) do
    params = []
    params = Header.merge_res(message, params)
    params = Body.merge_res(message, params)

    params
  end

  def response(message) do
    { Header.status(message), params(message)}
  end
end
