defmodule ResponseParser.RetrievalCommandReply do
  @moduledoc """
  ## Usage
  """

  def parse(server_response) when is_list(server_response) do
    # Second line of response
    data_match = Regex.run(%r/^(.*)\r\n$/, Enum.fetch!(server_response, 1))

    cond do
      default_match = Regex.run(%r/^VALUE ([^ ]*) ([^ ]*) ([^ ]*)\r\n/, Enum.fetch!(server_response, 0)) ->
        [
          key: Enum.fetch!(default_match, 1),
          flags: Enum.fetch!(default_match, 2),
          bytes: Enum.fetch!(default_match, 3),
          cas_unique: nil,
          data: Enum.fetch!(default_match, 1)
        ]
      cas_match = Regex.run(%r/^VALUE ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*)\r\n/, Enum.fetch!(server_response, 0)) ->
        [
          key: Enum.fetch!(cas_match, 1),
          flags: Enum.fetch!(cas_match, 2),
          bytes: Enum.fetch!(cas_match, 3),
          cas_unique: Enum.fetch!(cas_match, 4),
          data: Enum.fetch!(cas_match, 1)
        ]
      true ->
        raise(ArgumentError, message: "Unknown output from server.")
    end
  end
end
