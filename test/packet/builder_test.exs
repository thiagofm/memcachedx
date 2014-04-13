defmodule Memcachedx.Packet.BuilderTest do
  use ExUnit.Case
  alias Memcachedx.Packet.Builder, as: Builder
  doctest Builder

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
  test 'request get' do
    assert Builder.request([:get, [key: "Hello", cas: 0]]) == <<
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

  @doc """
      Byte/     0       |       1       |       2       |       3       |
         /              |               |               |               |
        |0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|0 1 2 3 4 5 6 7|
        +---------------+---------------+---------------+---------------+
       0| 0x80          | 0x02          | 0x00          | 0x05          |
        +---------------+---------------+---------------+---------------+
       4| 0x08          | 0x00          | 0x00          | 0x00          |
        +---------------+---------------+---------------+---------------+
       8| 0x00          | 0x00          | 0x00          | 0x12          |
        +---------------+---------------+---------------+---------------+
      12| 0x00          | 0x00          | 0x00          | 0x00          |
        +---------------+---------------+---------------+---------------+
      16| 0x00          | 0x00          | 0x00          | 0x00          |
        +---------------+---------------+---------------+---------------+
      20| 0x00          | 0x00          | 0x00          | 0x00          |
        +---------------+---------------+---------------+---------------+
      24| 0xde          | 0xad          | 0xbe          | 0xef          |
        +---------------+---------------+---------------+---------------+
      28| 0x00          | 0x00          | 0x0e          | 0x10          |
        +---------------+---------------+---------------+---------------+
      32| 0x48 ('H')    | 0x65 ('e')    | 0x6c ('l')    | 0x6c ('l')    |
        +---------------+---------------+---------------+---------------+
      36| 0x6f ('o')    | 0x57 ('W')    | 0x6f ('o')    | 0x72 ('r')    |
        +---------------+---------------+---------------+---------------+
      40| 0x6c ('l')    | 0x64 ('d')    |
        +---------------+---------------+
  """
  test 'request add' do
    assert Builder.request([:add, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10, extras: 8]]) == <<
      0x80, 0x02, 0x00, 0x05,
      0x08, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x12,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0xde, 0xad, 0xbe, 0xef,
      0x00, 0x00, 0x0e, 0x10,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>
  end

  test 'request set' do
    assert Builder.request([:set, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10, extras: 8]]) == <<
      0x80, 0x01, 0x00, 0x05,
      0x08, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x12,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0xde, 0xad, 0xbe, 0xef,
      0x00, 0x00, 0x0e, 0x10,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>
  end

  test 'request replace' do
    assert Builder.request([:replace, [key: "Hello", value: "World", cas: 0, flags: 0xdeadbeef, expiry: 0x00000e10, extras: 8]]) == <<
      0x80, 0x03, 0x00, 0x05,
      0x08, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x12,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0xde, 0xad, 0xbe, 0xef,
      0x00, 0x00, 0x0e, 0x10,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x57, 0x6f, 0x72,
      0x6c, 0x64
    >>
  end

  test 'request delete' do
    assert Builder.request([:delete, [key: "Hello"]]) == <<
      0x80, 0x04, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f
    >>
  end

  test 'request incr' do
    assert Builder.request([:incr, [key:
        "counter", extras: 20, delta: 0x01, initial: 0x00, expiration: 0x00000e10]]) == <<
      0x80, 0x05, 0x00, 0x07,
      0x14, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x1b,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x01,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x0e, 0x10,
      0x63, 0x6f, 0x75, 0x6e,
      0x74, 0x65, 0x72
    >>
  end

  test 'request decr' do
    assert Builder.request([:decr, [key:
        "counter", extras: 20, delta: 0x01, initial: 0x00, expiration: 0x00000e10]]) == <<
      0x80, 0x06, 0x00, 0x07,
      0x14, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x1b,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x01,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x0e, 0x10,
      0x63, 0x6f, 0x75, 0x6e,
      0x74, 0x65, 0x72
    >>
  end

  test 'request quit' do
    assert Builder.request([:quit, []]) == <<
      0x80, 0x07, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00
    >>
  end

  test 'request flush' do
    assert Builder.request([:flush, [expiration: 0x000e10, extras: 4]]) == <<
      0x80, 0x08, 0x00, 0x00,
      0x04, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x04,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x0e, 0x10
    >>
  end

  test 'request noop' do
    assert Builder.request([:noop, []]) == <<
      0x80, 0x0a, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00
    >>
  end

  test 'request version' do
    assert Builder.request([:version, []]) == <<
      0x80, 0x0b, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00
    >>
  end

  test 'request append' do
    assert Builder.request([:append, [key: "Hello", value: "!"]]) == <<
      0x80, 0x0e, 0x00, 0x05,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x06,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x48, 0x65, 0x6c, 0x6c,
      0x6f, 0x21
    >>
  end
end
