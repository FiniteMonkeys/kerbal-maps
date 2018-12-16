defmodule KSPMaps.WaypointsParser do
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
      "WAYPOINT" <> remaining ->
        {:ok, data, remaining, stream}
        |> parse_waypoint
    end
  end

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

  # [name: "Name", value: "value"]
  def resolve_pair([{:name, name}, {:value, value}]), do: [{:name, name}, {:value, value}]

  defcombinatorp :pair,
    name
    |> ignore(repeat(whitespace_char))
    |> ignore(utf8_char([?=]))
    |> concat(value)
    |> reduce(:resolve_pair)

  # {
  # 	name = The Great Desert
  # 	celestialName = Kerbin
  # 	latitude = 2.4902494069446099
  # 	longitude = 218.604135349567
  # 	navigationId = 87b0c496-500d-426f-b9b3-dbf75c2320e4
  # 	icon = eva
  # 	altitude = 3.4106051316484809E-13
  # 	index = 0
  # 	seed = 173
  # }
  defparsec :waypoint,
    ignore(repeat(whitespace_char))
    |> ignore(utf8_char([?{]))
    |> repeat(lookahead_not(utf8_char([?}])) |> parsec(:pair))
    |> ignore(utf8_char([?}]))
    |> tag(:waypoint)
    |> ignore(repeat(whitespace_char))

  def parse_waypoint({:ok, _, "", _} = state), do: reload_buffer(state) |> parse_waypoint
  def parse_waypoint({:ok, data, buffer, stream}) do
    # Logger.warn fn -> inspect(waypoint(buffer)) end
    # {:ok, [waypoint: [[name: "name ", value: " foo "]]], "remainder", %{}, {1, 0}, 15}
    case waypoint(buffer) do
      {:ok, [waypoint: [[name: name, value: value]]], remainder, _, _, _} ->
        {:ok, [data, %{name => value}], remainder, stream}
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
