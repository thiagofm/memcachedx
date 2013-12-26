defmodule Memcachedx do
  def connect_and_send do
    host = 'localhost'
    port = 11211
    {ok, socket} = :gen_tcp.connect(host, port, [], 1)

    ok = :gen_tcp.send(socket, "get mykey")
    ok = :gen_tcp.close(socket)
  end
end
