defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """
  def status(message) do
    status = slice_and_sum(message, 6, 2)
    case status do
      0 -> :ok
      _ -> :error
    end
  end

  def params(message) do
    params = [cas: slice_and_sum(message, 16,8)]

    if slice_and_sum(message, 8, 4) > 0 do
      params = params ++ [total_body: Enum.slice(message, 8, 4) |> Enum.reduce(&+/2)]
    end

    params
  end

  def response(message) do
    { status(message), params(message)}
  end

  defp slice_and_sum(message, from, to) do
    Enum.slice(message, from, to) |> Enum.reduce(&+/2)
  end
end
