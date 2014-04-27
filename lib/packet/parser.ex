defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def body(params, body) do
    key_length = params[:key_length]
    value_length = params[:total_body_length] - params[:key_length] - params[:extras_length]

    # Solves problem with getk/getkq having the wrong total_body_length as the
    # total_body_length should be (extras_length + key_length + value_length)
    if params[:opcode] == :getk do
      value_length = params[:total_body_length] - params[:extras_length]
    end

    if key_length > 0 do
      <<
        key :: [binary, size(key_length)],
        body :: binary
      >> = body
    else
      key = ""
    end

    if value_length > 0 do
      <<
        value :: [binary, size(value_length)],
        body :: binary
      >> = body
    else
      value = ""
    end

    params = params ++ [key: key, value: value]

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

  def recur_response(message, acc) do
    <<
      magic :: [size(1), unit(8)],
      opcode :: [size(1), unit(8)],
      key_length :: [size(2), unit(8)],
      extras_length :: [size(1), unit(8)],
      data_type :: [size(1), unit(8)],
      status :: [size(2), unit(8)],
      rest :: binary
    >> = message

    if Kernel.byte_size(rest) > 0 do
      <<
        total_body_length :: [size(4), unit(8)],
        opaque :: [size(4), unit(8)],
        cas :: [size(8), unit(8)],
        rest :: binary
      >> = rest

      <<
        extras :: [size(extras_length), unit(8)],
        body :: [binary, size(total_body_length)],
        rest :: binary
      >> = rest

      params = [
        opcode: opcode(opcode),
        key_length: key_length,
        extras_length: extras_length,
        total_body_length: total_body_length,
        opaque: opaque,
        cas: cas,
        extras: extras
      ] |> body(body)
    else
      params = [
        opcode: opcode(opcode),
        key_length: key_length,
        extras_length: extras_length,
      ]
    end

    # status
    if status == 0 do
      status = :ok
    else
      status = :error
    end

    if Kernel.byte_size(rest) > 0 do
      recur_response(rest, acc ++ [{status, params}])
    else
      acc
    end
  end

  def response(message) do
    <<
      magic :: [size(1), unit(8)],
      opcode :: [size(1), unit(8)],
      key_length :: [size(2), unit(8)],
      extras_length :: [size(1), unit(8)],
      data_type :: [size(1), unit(8)],
      status :: [size(2), unit(8)],
      rest :: binary
    >> = message

    if Kernel.byte_size(rest) > 0 do
      <<
        total_body_length :: [size(4), unit(8)],
        opaque :: [size(4), unit(8)],
        cas :: [size(8), unit(8)],
        rest :: binary
      >> = rest

      <<
        extras :: [size(extras_length), unit(8)],
        body :: [binary, size(total_body_length)],
        rest :: binary
      >> = rest

      params = [
        opcode: opcode(opcode),
        key_length: key_length,
        extras_length: extras_length,
        total_body_length: total_body_length,
        opaque: opaque,
        cas: cas,
        extras: extras
      ] |> body(body)
    else
      params = [
        opcode: opcode(opcode),
        key_length: key_length,
        extras_length: extras_length,
      ]
    end

    # status
    if status == 0 do
      status = :ok
    else
      status = :error
    end

    if Kernel.byte_size(rest) > 0 do
      recur_response(rest, [{status, params}])
    else
      [{status, params}]
    end
  end
end
