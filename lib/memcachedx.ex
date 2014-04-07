defmodule Memcachedx do
  def connect_and_send do
    host = 'localhost'
    port = 11211
    {ok, socket} = :gen_tcp.connect(host, port, [], 1)

    ok = :gen_tcp.send(socket, "get mykey")
    ok = :gen_tcp.close(socket)
  end

  def connect_and_send_binary do
    host = 'localhost'
    port = 11211
    {ok, socket} = :gen_tcp.connect(host, port, [:binary, {:packet, 0}])

    key = "hello"
    value = "world"
    ok = :gen_tcp.send(socket,
      <<
        0x80, # magic
        0x01, # opcode
        Kernel.byte_size(key) :: [size(2), unit(8)], # key length

        0x08, # extras length
        0x00, # data type
        0x00 :: [size(2), unit(8)], # reserved

        (0x08 + Kernel.byte_size(key) + Kernel.byte_size(value)) :: [size(4), unit(8)], # total body length

        0x69 :: [size(4), unit(8)], # opaque
        0x00 :: [size(8), unit(8)], # cas
        0xdeadbeef :: [size(4), unit(8)], # flags
        0x00000e10 :: [size(4), unit(8)], # expiry
        key :: binary, # key
        value :: binary # value
      >>
    )
    ok = :gen_tcp.close(socket)
  end
end
