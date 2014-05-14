defexception Memcachedx.Error do
  def message(exception) do
    "#{IO.inspect(exception)}"
  end
end
