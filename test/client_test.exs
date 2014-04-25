defmodule Memcachedx.ConnectionTest do
  use ExUnit.Case
  alias Memcachedx.Connection, as: Connection

  test :example do
    tree = [ worker(Repo, []) ]
    supervise(tree, strategy: :one_for_all)
    IO.inspect tree
  end
end
