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
    case :gen_tcp.connect(options[:hostname], options[:port], []) do
      { :ok, sock } ->
        IO.inspect sock
        s = state(options: options, sock: {:gen_tcp, sock}, reply_to: from)
        { :noreply, state(s, state: :auth) }
      { :error, reason } ->
        { :stop, :normal, raise("Can't connect: #{reason}") } #TODO: Add personalized error
    end
  end

  def handle_cast(msg, from) do
  end

  def handle_info(msg, from) do
  end

  def terminate(reasion, state) do
  end

  def code_change(old_vsn, state, extra) do
  end
end
