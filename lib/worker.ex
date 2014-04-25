defmodule Memcachedx.Worker do
 @moduledoc false

  use GenServer.Behaviour

  defrecordp :state, [ :conn, :params, :monitor ]

  @timeout 5000

  def start(args) do
    :gen_server.start(__MODULE__, args, [])
  end

  def start_link(args) do
    :gen_server.start_link(__MODULE__, args, [])
  end

  def run(worker, cmd, timeout \\ @timeout) do
    case :gen_server.call(pid, {:run, cmd}) do
      res -> res
    end
  end

  def monitor_me(worker) do
    :gen_server.cast(worker, { :monitor, self })
  end

  def demonitor_me(worker) do
    :gen_server.cast(worker, { :demonitor, self })
  end

  def init(opts) do
    Process.flag(:trap_exit, true)

    lazy? = opts[:lazy] in [false, "false"]

    conn =
      case lazy? and Memcachedx.Connection.start_link(opts) do
        { :ok, conn } -> conn
        _ -> nil
      end

    { :ok, state(conn: conn, params: opts) }
  end

  # Connection is disconnected, reconnect before continuing
  def handle_call(request, from, state(conn: nil, params: params) = s) do
    case Memcachedx.Connection.start_link(params) do
      { :ok, conn } ->
        handle_call(request, from, state(s, conn: conn))
      { :error, err } ->
        { :reply, { :error, err }, s }
    end
  end

  def handle_call({ :run!, params, timeout }, _from, state(conn: conn) = s) do
    { :reply, Memcachedx.Connection.run(conn, params), s }
  end

  def handle_cast({ :monitor, pid }, state(monitor: nil) = s) do
    ref = Process.monitor(pid)
    { :noreply, state(s, monitor: { pid, ref }) }
  end

  def handle_cast({ :demonitor, pid }, state(monitor: { pid, ref }) = s) do
    Process.demonitor(ref)
    { :noreply, state(s, monitor: nil) }
  end

  def handle_info({ :EXIT, conn, _reason }, state(conn: conn) = s) do
    { :noreply, state(s, conn: nil) }
  end

  def handle_info({ :DOWN, ref, :process, pid, _info }, state(monitor: { pid, ref }) = s) do
    { :stop, :normal, s }
  end

  def handle_info(_info, s) do
    { :noreply, s }
  end

  def terminate(_reason, state(conn: nil)) do
    :ok
  end

  def terminate(_reason, state(conn: conn)) do
    Memcachedx.Connection.stop(conn)
  end
end
