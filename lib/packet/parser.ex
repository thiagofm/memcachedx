defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """
  def response(message) do
    { status(message), params(message)}
  end

  def status(message) do
    status = slice_and_sum(message, 6, 2)
    case status do
      0 -> :ok
      _ -> :error
    end
  end

  def opcode(message, params) do
    opcode = case Enum.at(message, 1) do
      0x00 -> :get
      0x01 -> :set
      0x02 -> :add
      0x03 -> :replace
      0x04 -> :delete
      0x05 -> :incr
      0x06 -> :decr
      0x07 -> :quit
      0x08 -> :flush
      0x0A -> :noop
      0x0B -> :version
      0x0D -> :getkq
      0x0E -> :append
      0x0F -> :prepend
      0x10 -> :stat
      0x11 -> :setq
      0x12 -> :addq
      0x13 -> :replaceq
      0x14 -> :deleteq
      0x15 -> :incrq
      0x16 -> :decrq
    end

    params = params ++ [opcode: opcode]
    params
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

  def total_body(message, params) do
    if slice_and_sum(message, 8, 4) > 0 do
      params = params ++ [total_body: Enum.slice(message, 8, 4) |> Enum.reduce(&+/2)]
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

  def params(message) do
    params = [cas: slice_and_sum(message, 16,8)]
    params = opcode(message, params)
    params = total_body(message, params)
    params = body(message, params)

    params
  end

  defp slice_and_sum(message, from, to) do
    Enum.slice(message, from, to) |> Enum.reduce(&+/2)
  end
end
