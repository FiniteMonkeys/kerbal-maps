defmodule KerbalMaps.ParserHelpers do
  import NimbleParsec

  def fractional_part(combinator \\ empty()), do: combinator |> integer(min: 1)
  def integer_part(combinator \\ empty()), do: combinator |> integer(min: 1)
  def sign(combinator \\ empty()), do: combinator |> optional(utf8_char([?+, ?-])) |> tag(:sign)

  # [{:sign, '+'}, 456]
  def resolve_integer_sign([{:sign, '+'}, value]), do: value
  # [{:sign, '-'}, 789]
  def resolve_integer_sign([{:sign, '-'}, value]), do: -value
  # [{:sign, []}, 123]
  def resolve_integer_sign([{:sign, []}, value]), do: value

  # [-789, 0]
  def resolve_real([integer_part, fractional_part]), do: String.to_float("#{integer_part}.#{fractional_part}")

  def resolve_latitude([?N, {:real, value}]), do: {:real, value}
  def resolve_latitude([{:real, value}, ?N]), do: {:real, value}
  def resolve_latitude([?n, {:real, value}]), do: {:real, value}
  def resolve_latitude([{:real, value}, ?n]), do: {:real, value}
  def resolve_latitude([?S, {:real, value}]), do: {:real, -value}
  def resolve_latitude([{:real, value}, ?S]), do: {:real, -value}
  def resolve_latitude([?s, {:real, value}]), do: {:real, -value}
  def resolve_latitude([{:real, value}, ?s]), do: {:real, -value}

  def resolve_longitude([?E, {:real, value}]), do: {:real, value}
  def resolve_longitude([{:real, value}, ?E]), do: {:real, value}
  def resolve_longitude([?e, {:real, value}]), do: {:real, value}
  def resolve_longitude([{:real, value}, ?e]), do: {:real, value}
  def resolve_longitude([?W, {:real, value}]), do: {:real, -value}
  def resolve_longitude([{:real, value}, ?W]), do: {:real, -value}
  def resolve_longitude([?w, {:real, value}]), do: {:real, -value}
  def resolve_longitude([{:real, value}, ?w]), do: {:real, -value}
end
