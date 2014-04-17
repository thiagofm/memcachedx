defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """
  def status(message) do
    status = Enum.at(message, 6) + Enum.at(message, 7)
    case status do
      0 -> :ok
      _ -> :error
    end
  end

  def params(message) do
    [cas: Enum.slice(message, 16, 8) |> Enum.reduce(&+/2)]
  end

  def response(message) do
    { status(message), params(message)}
  end
end
