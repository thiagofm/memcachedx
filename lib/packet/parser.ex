defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def params(message) do
    params = []
    params = Header.opcode(message, params)
    params = Header.total_body(message, params)
    params = Header.cas(message, params)
    params = Body.merge_res(message, params)

    params
  end

  def response(message) do
    { Header.status(message), params(message)}
  end

  defp slice_and_sum(message, from, to) do
    Enum.slice(message, from, to) |> Enum.reduce(&+/2)
  end
end
