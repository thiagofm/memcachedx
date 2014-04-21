defmodule Memcachedx.Packet.Parser do
  @doc """
  Parses the response to find the status code and return a friendly message
  based on it.
  """

  alias Memcachedx.Packet.Response.Header, as: Header
  alias Memcachedx.Packet.Response.Body, as: Body

  def params(message) do
    Header.merge_res(message, []) |> Body.merge_res(message)
  end

  def response(message) do
    status   = Header.status(message)
    params   = params(message)
    response = {status, params}

    if composite_response?(message, params) do
      Enum.reverse(recursively_parse_response(offset_message(message, params), params, [response]))
    else
      response
    end
  end

  @doc """
  Recursively parses response adding all responses up in the acc variable.
  This happens because some opcodes rely on more than one response like
  the stat command.

  The stat command, for instance, returns each key and value in a separate
  response, so we need to deal with it and build a list of responses.

  The acc is started with the first parsed response from the "response"
  function call.
  """
  def recursively_parse_response(message, params, acc) do
    if composite_response?(message, params) do
      status   = Header.status(message)
      params   = params(message)
      response = {status, params}

      recursively_parse_response(
        offset_message(message, params),
        params,
        [response] ++ acc
      )
    else
      acc
    end
  end

  @doc """
  Offsets the current message by the amount of bytes it has already proccessed.
  """
  defp offset_message(message, params) do
    Enum.slice(message, (24 + params[:total_body]..-1))
  end

  defp composite_response?(message, params) do
    Enum.count(message) > 24 + params[:total_body]
  end
end
