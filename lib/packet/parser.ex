defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header

  def params(message) do
    params = [cas: slice_and_sum(message, 16,8)]
    params = Header.opcode(message, params)
    params = Header.total_body(message, params)
    params = body(message, params)

    params
  end

  def response(message) do
    { Header.status(message), params(message)}
  end

  def body_parser(body, params) do
    keys = extra_vars_for(params[:opcode])
    size = Enum.count(keys)
    total_body = params[:total_body]

    params = Enum.reduce(keys, [], fn (item, acc) ->
      case item do
        :value -> acc = acc ++ [value: Kernel.list_to_bitstring(Enum.slice(body, 0, total_body))]
      end
      acc
    end)

    params
  end

  def body(message, params) do
    if Enum.count(message) > 24 do
      params = params ++ body_parser(Enum.slice(message, 24, params[:total_body]), params)
    end
    params
  end

  @doc """
  Returns the necessary extra vars for the defined opcode
  """
  def extra_vars_for(opcode) do
    case opcode do
      opcode when opcode in [:incr, :decr] -> [:value]
      opcode when opcode in [:delete] -> [:value]
      _ -> []
    end
  end

  defp slice_and_sum(message, from, to) do
    Enum.slice(message, from, to) |> Enum.reduce(&+/2)
  end
end
