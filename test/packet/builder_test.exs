defmodule Memcachedx.Packet.BuilderTest do
  use ExUnit.Case

  @doc """
        Byte/     0       |       1       |       2       |       3       |
           /              |               |               |               |
          |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
          +---------------+---------------+---------------+---------------+
         0| 0x80          | 0x00          | 0x00          | 0x05          |
          +---------------+---------------+---------------+---------------+
         4| 0x00          | 0x00          | 0x00          | 0x00          |
          +---------------+---------------+---------------+---------------+
         8| 0x00          | 0x00          | 0x00          | 0x05          |
          +---------------+---------------+---------------+---------------+
        12| 0x00          | 0x00          | 0x00          | 0x00          |
          +---------------+---------------+---------------+---------------+
        16| 0x00          | 0x00          | 0x00          | 0x00          |
          +---------------+---------------+---------------+---------------+
        20| 0x00          | 0x00          | 0x00          | 0x00          |
          +---------------+---------------+---------------+---------------+
        24| 0x48 ('H')    | 0x65 ('e')    | 0x6c ('l')    | 0x6c ('l')    |
          +---------------+---------------+---------------+---------------+
        28| 0x6f ('o')    |

  """
  test :requirements_full do
    options = [key: "xpto", cas: 3, opaque: 2]
    require Memcachedx.Packet.Builder
    Memcachedx.Packet.Builder.requirements(:get)
    assert key == "xpto"
    assert cas == 3
    assert opaque == 2
  end

  test :requirements_empty do
    options = [key: "xpto"]
    require Memcachedx.Packet.Builder
    Memcachedx.Packet.Builder.requirements(:get)
    assert key == "xpto"
    assert cas == 0
    assert opaque == 0
  end

  test :request do
    #host = 'localhost'
    #port = 11211
    #{ok, socket} = :gen_tcp.connect(host, port, [:binary, {:packet, 0}])

    #key = "hello"
    #value = "world"
    #ok = :gen_tcp.send(socket,
      #Memcachedx.Packet.Builder.request([:get, [key: "Hello", cas: 0, flags: 0]])
    #)
    #ok = :gen_tcp.close(socket)

    assert Memcachedx.Packet.Builder.request([:get, [key: "Hello", cas: 0, flags: 0]]) == <<
      0x80, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f
    >>
  end
end
