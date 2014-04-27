defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def body(params, body) do
    # flags
    extras_offset = 0
    if params[:extras_length] > 0 do
      params = params ++ [extras: String.slice(body, 0, params[:extras_length] - 1)]
      extras_offset = 1
    end

    # key
    if params[:key_length] > 0 do
      params = params ++ [key: String.slice(body, params[:extras_length] - extras_offset, params[:key_length])]
    end

    # value
    value = params[:total_body_length] - params[:key_length]
    if value > 0 do
      params = params ++ [value: String.slice(body, params[:key_length] + params[:extras_length] - extras_offset, value + 1)]
    end

    params
  end

  def opcode(opcode) do
    case opcode do
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
  end

  def res_header(message) do
    <<
      magic :: [size(1), unit(8)],
      opcode :: [size(1), unit(8)],
      key_length :: [size(2), unit(8)],
      extras_length :: [size(1), unit(8)],
      data_type :: [size(1), unit(8)],
      status :: [size(2), unit(8)],
      total_body_length :: [size(4), unit(8)],
      opaque :: [size(4), unit(8)],
      cas :: [size(8), unit(8)],
      rest :: binary
    >> = message

    # status
    if status == 0 do
      status = :ok
    else
      status = :error
    end

    arr = [
      opcode: opcode(opcode),
      key_length: key_length,
      extras_length: extras_length,
      total_body_length: total_body_length,
      opaque: opaque,
      cas: cas
    ] |> body(rest)

    {status, arr}
  end

  def params(message) do
    Header.merge_res(message, []) |> Body.merge_res(message)
  end

  def response(message) do
    message  = :erlang.binary_to_list(message)

    status   = Header.status(message)
    params   = params(message)
    response = {status, params}

    if composite_response?(message, params) do
      Enum.reverse(recursively_parse_response(offset_message(message, params), params, [response]))
    else
      response
    end
  end

  @doc """
  Recursively parses response adding all responses up in the acc variable.
  This happens because some opcodes rely on more than one response like
  the stat command.

  The stat command, for instance, returns each key and value in a separate
  response, so we need to deal with it and build a list of responses.

  The acc is started with the first parsed response from the "response"
  function call.
  """
  def recursively_parse_response(message, params, acc) do
    if composite_response?(message, params) do
      status   = Header.status(message)
      params   = params(message)
      response = {status, params}

      recursively_parse_response(
        offset_message(message, params),
        params,
        [response] ++ acc
      )
    else
      acc
    end
  end

  defp offset_message(message, params) do
    Enum.slice(message, (24 + params[:total_body]..-1))
  end

  defp composite_response?(message, params) do
    Enum.count(message) > 24 + params[:total_body]
  end
end
