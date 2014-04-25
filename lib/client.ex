defmodule Memcachedx.Client do
  @default_port 5432
  @timeout 5000

  defmacro __using__(_opts) do
    quote do
      def __memcached__(:pool_name) do
        __MODULE__.Pool
      end
    end
  end

  def start_link(repo, opts) do
    { pool_opts, worker_opts } = prepare_start(repo, opts)
    :poolboy.start_link(pool_opts, worker_opts)
  end

  def run(repo, cmd) do
    use_worker(repo, timeout, fn worker ->
      Worker.run(worker, cmd, timeout)
    end)
  end

  defp use_worker(repo, timeout, fun) do
    pool = repo.__memcached__(:pool_name)
    key = { :memcachedx_transaction_pid, pool }

    if value = Process.get(key) do
      in_transaction = true
      worker = elem(value, 0)
    else
      worker = :poolboy.checkout(pool, true, timeout)
    end

    try do
      fun.(worker)
    after
      if !in_transaction do
        :poolboy.checkin(pool, worker)
      end
    end
  end

  def stop(repo) do
    pool_name = repo.__postgres__(:pool_name)
    :poolboy.stop(pool_name)
  end

  defp prepare_start(repo, opts) do
    pool_name = repo.__postgres__(:pool_name)
    { pool_opts, worker_opts } = Dict.split(opts, [:size, :max_overflow])

    pool_opts = pool_opts
      |> Keyword.update(:size, 5, &binary_to_integer(&1))
      |> Keyword.update(:max_overflow, 10, &binary_to_integer(&1))

    pool_opts = [
      name: { :local, pool_name },
      worker_module: Worker ] ++ pool_opts

    worker_opts = worker_opts
      |> Keyword.put(:decoder, &decoder/4)
      |> Keyword.put_new(:port, @default_port)

    { pool_opts, worker_opts }
  end
end
