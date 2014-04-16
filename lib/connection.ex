defmodule Memcachedx.Connection do
  @moduledoc """
    Responsable for keeping state of the tcp connection with memcached
  """

  use GenServer.Behaviour

  defrecordp :state, [ :state, :reply_to, :reply, :sock, :options]

  @doc """
  ## Options
  * hostname: the memcached server hostname
  * port: the memcached server port
  """

  def init([]) do
    { :ok, state(state: :ready) }
  end

  def start_link(options) do
    case :gen_server.start_link(__MODULE__, [], []) do
      { :ok, pid } ->
        options = options |> Keyword.update!(:hostname, &if is_binary(&1), do: String.to_char_list!(&1), else: &1)
        case :gen_server.call(pid, { :connect, options }) do
          :ok -> { :ok, pid }
          err -> { :error, err }
        end
      err -> err
    end
  end

  def handle_call({:connect, options}, from, state(state: :ready) = s) do
    case :gen_tcp.connect(options[:hostname], options[:port], [ {:active, :once}, { :packet, :raw }]) do
      { :ok, sock } ->
        s = state(state: :ready, options: options, sock: {:gen_tcp, sock}, reply_to: from)
        { :reply, :ok, s }
      { :error, reason } ->
        { :stop, :normal, raise("Can't connect: #{reason}") } #TODO: Add personalized error
    end
  end

  def handle_call(:stop, from, state(state: :ready) = s) do
    {:stop, :normal, state(s, reply_to: from) }
  end

  def handle_call({:run_command, cmd}, from, state(state: :ready, sock: sock) = s) do
    el = Memcachedx.Packet.Builder.request(cmd)

    { mod, sock } = sock

    case mod.send(sock, el) do
      :ok -> :ok
      :error -> raise("Stuff")
    end

    { :noreply, state(s, reply_to: from) }
  end

  def handle_info({:tcp_closed, _}, state(reply_to: to) = s) do
    error = "TCP closed"

    if to do
      :gen_server.reply(to, error)
      { :stop, :normal, s }
    else
      { :stop, error, s }
    end
  end

  def handle_info({:tcp, sock, msg}, state(reply_to: to) = s) do
    Memcachedx.Packet.Parser.response(msg)

    :gen_server.reply(to, {:ok, :stored})
    { :noreply, state }
  end

  def stop(pid) do
    :gen_server.call(pid, :stop)
  end

  def terminate(reason, state(sock: sock, reply_to: to, reply: reply)) do
    if sock do
      { mod, sock } = sock
      mod.close(sock)
    end

    if to do
      if reason == :normal do
        :gen_server.reply(to, reply || :ok)
      else
        :gen_server.reply(to, raise("terminated: #{inspect reason}"))
      end
    end
  end

  def run(pid, cmd) do
    case :gen_server.call(pid, {:run_command, cmd}) do
      {:ok, res} -> {:ok, res}
    end
  end

  def code_change(old_vsn, state, extra) do
  end
end
