defrecord Memcachedx.Result, [:command, :response]

defexception Memcachedx.Error, [:message] do
  def message(exception) do
    exception
  end
end
