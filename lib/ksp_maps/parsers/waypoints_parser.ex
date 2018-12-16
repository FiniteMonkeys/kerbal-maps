defmodule KSPMaps.WaypointsParser do
  @moduledoc false

  require Logger

  def parse_comment({:ok, data, stream}), do: parse_comment({:ok, data, "", stream})
  def parse_comment({:ok, _, "", _} = state), do: reload_buffer(state) |> parse_comment
  def parse_comment({:ok, data, buffer, stream}) do
    case buffer do
      "//" <> remaining ->
        {:ok, data, remaining, stream}
        |> strip_comment
      _ ->
        {:not_found, data, buffer, stream}
    end
  end

  defp strip_comment({:ok, data, <<10, remaining::binary>>, stream}), do: {:ok, data, remaining, stream}
  defp strip_comment({:ok, data, <<13, 10, remaining::binary>>, stream}), do: {:ok, data, remaining, stream}
  defp strip_comment({:ok, data, <<13, remaining::binary>>, stream}), do: {:ok, data, remaining, stream}
  defp strip_comment({:ok, _, "", _} = state), do: reload_buffer(state) |> strip_comment
  defp strip_comment({:ok, data, <<_::bytes-size(1), remaining::binary>>, stream}), do: strip_comment({:ok, data, remaining, stream})

  defp reload_buffer({_, data, buffer, stream}) do
    case IO.binread(stream, 1024) do
      :eof ->
        {:eof, data, buffer, stream}
      {:error, _} = error_reason ->
        error_reason
      new_chunk ->
        {:ok, data, buffer <> new_chunk, stream}
    end
  end
end
