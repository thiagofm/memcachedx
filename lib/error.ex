defexception Memcachedx.Error, [:message] do
  def message(exception) do
    "#{IO.inspect(exception)}"
  end
end
