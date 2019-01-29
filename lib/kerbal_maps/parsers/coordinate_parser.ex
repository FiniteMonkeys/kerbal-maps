defmodule KerbalMaps.CoordinateParser do
  @moduledoc false

  require Logger

  import NimbleParsec
  import KerbalMaps.ParserHelpers

  def parse(str),
    do:
      str
      |> KerbalMaps.CoordinateParser.pair
      |> reformat_parser_output

  # {:ok, [real: 20.6709, real: -146.4968], "", %{}, {1, 0}, 17}
  def reformat_parser_output({:ok, array, _, _, _, _}), do: Enum.map(array, fn term -> elem(term, 1) end)

  # nul, \t, \n, \f, \r, space respectively
  whitespace_values = [0, 9, 10, 12, 13, 32]
  whitespace_char = utf8_char(whitespace_values)

  bare_pair_separator = ignore(repeat(whitespace_char))
                        |> ignore(optional(utf8_char([?,])))
                        |> ignore(repeat(whitespace_char))
  pair_separator = ignore(repeat(whitespace_char))
                   |> ignore(utf8_char([?,]))
                   |> ignore(repeat(whitespace_char))

  cardinal_latitude = utf8_char([?N, ?n, ?S, ?s])
  cardinal_longitude = utf8_char([?E, ?e, ?W, ?w])

  real = sign()
         |> integer_part()
         |> reduce(:resolve_integer_sign)
         |> ignore(utf8_char([?.]))
         |> fractional_part()
         |> reduce(:resolve_real)
         |> unwrap_and_tag(:real)

  unsigned_real = integer_part()
                  |> ignore(utf8_char([?.]))
                  |> fractional_part()
                  |> reduce(:resolve_real)
                  |> unwrap_and_tag(:real)

  bare_latitude = concat(empty(), real)
  bare_longitude = concat(empty(), real)

  prefixed_latitude = concat(empty(), cardinal_latitude)
                      |> ignore(repeat(whitespace_char))
                      |> concat(unsigned_real)
                      |> reduce(:resolve_latitude)
  prefixed_longitude = concat(empty(), cardinal_longitude)
                       |> ignore(repeat(whitespace_char))
                       |> concat(unsigned_real)
                       |> reduce(:resolve_longitude)

  postfixed_latitude = concat(empty(), unsigned_real)
                       |> ignore(repeat(whitespace_char))
                       |> concat(cardinal_latitude)
                       |> reduce(:resolve_latitude)
  postfixed_longitude = concat(empty(), unsigned_real)
                        |> ignore(repeat(whitespace_char))
                        |> concat(cardinal_longitude)
                        |> reduce(:resolve_longitude)

  bare_pair = bare_latitude
              |> concat(bare_pair_separator)
              |> concat(bare_longitude)
  prefixed_pair = prefixed_latitude
                  |> concat(pair_separator)
                  |> concat(prefixed_longitude)
  postfixed_pair = postfixed_latitude
                   |> concat(pair_separator)
                   |> concat(postfixed_longitude)

  defparsec :pair, choice([prefixed_pair, postfixed_pair, bare_pair])
end
