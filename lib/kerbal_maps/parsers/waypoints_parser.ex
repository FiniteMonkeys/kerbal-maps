defmodule KerbalMaps.WaypointsParser do
  @moduledoc false

  require Logger

  import NimbleParsec

  def parse({:ok, data, stream}), do: parse({:ok, data, "", stream})
  def parse({:ok, _, "", _} = state), do: reload_buffer(state) |> parse
  def parse({:ok, data, buffer, stream}) do
    case buffer do
      "//" <> remaining ->
        {:ok, data, remaining, stream}
        |> strip_comment
        |> parse
      "WAYPOINT" <> remaining ->
        {:ok, data, remaining, stream}
        |> parse_waypoint
        |> parse
    end
  end
  def parse({:eof, data, "", stream}), do: {:ok, List.flatten(data), "", stream}

  def strip_comment({:ok, data, <<10, remaining::binary>>, stream}), do: {:ok, data, remaining, stream}
  def strip_comment({:ok, data, <<13, 10, remaining::binary>>, stream}), do: {:ok, data, remaining, stream}
  def strip_comment({:ok, data, <<13, remaining::binary>>, stream}), do: {:ok, data, remaining, stream}
  def strip_comment({:ok, _, "", _} = state), do: reload_buffer(state) |> strip_comment
  def strip_comment({:ok, data, <<_::bytes-size(1), remaining::binary>>, stream}), do: strip_comment({:ok, data, remaining, stream})

  # nul, \t, \n, \f, \r, space respectively
  whitespace_values = [0, 9, 10, 12, 13, 32]
  whitespace_char = utf8_char(whitespace_values)

  # \n, \r, } respectively
  value_terminator_values = [10, 13, ?}]
  value_terminator_char = utf8_char(value_terminator_values)

  name = ignore(repeat(whitespace_char))
         |> repeat(lookahead_not(utf8_char([?=])) |> utf8_char([]))
         |> reduce({List, :to_string, []})
         |> map({String, :trim, []})
         |> unwrap_and_tag(:name)

  value = repeat(lookahead_not(value_terminator_char) |> utf8_char([]))
          |> reduce({List, :to_string, []})
          |> map({String, :trim, []})
          |> unwrap_and_tag(:value)
          |> ignore(repeat(whitespace_char))

  def resolve_pair([{:name, name}, {:value, value}]), do: [{name, value}]

  defcombinatorp :pair,
    name
    |> ignore(repeat(whitespace_char))
    |> ignore(utf8_char([?=]))
    |> concat(value)
    |> reduce(:resolve_pair)

  defparsec :waypoint,
    ignore(repeat(whitespace_char))
    |> ignore(utf8_char([?{]))
    |> repeat(lookahead_not(utf8_char([?}])) |> parsec(:pair))
    |> ignore(utf8_char([?}]))
    |> tag(:waypoint)
    |> ignore(repeat(whitespace_char))

  def parse_waypoint({:ok, _, "", _} = state), do: reload_buffer(state) |> parse_waypoint
  def parse_waypoint({:ok, data, buffer, stream}) do
    case waypoint(buffer) do
      {:ok, [waypoint: pairs_list], remainder, _, _, _} ->
        {:ok, [data, Enum.reduce(List.flatten(pairs_list), %{}, fn {key, value}, acc -> Map.put(acc, key, value) end)], remainder, stream}
      {:error, error_message, remainder, _, _, _} ->
        {:error, error_message, remainder, stream}
    end
  end

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
