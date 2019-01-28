defmodule KerbalMaps.CoordinateParser.Spec do
  @moduledoc false

  use ESpec

  doctest KerbalMaps.CoordinateParser

  example_group "parsing a coordinate pair" do
    let :output, do: input() |> KerbalMaps.CoordinateParser.pair
    let :status, do: elem(output(), 0)
    let :acc, do: elem(output(), 1)
    let :rest, do: elem(output(), 2)
    # let :context, do: elem(output(), 3)
    # let :line, do: elem(output(), 4)
    # let :column, do: elem(output(), 5)

    # e.g. 20.6709, -146.4968
    describe "given a bare decimal pair" do
      context "separated by a comma" do
        let :input, do: "20.6709,-146.4968"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([real: 20.6709, real: -146.4968]))
          expect (rest()) |> to(eq(""))
        end
      end

      context "separated by whitespace" do
        let :input, do: "20.6709 -146.4968"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([real: 20.6709, real: -146.4968]))
          expect (rest()) |> to(eq(""))
        end
      end

      context "separated by a comma and whitespace" do
        let :input, do: "20.6709, -146.4968"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([real: 20.6709, real: -146.4968]))
          expect (rest()) |> to(eq(""))
        end
      end
    end

    # e.g. N 20.6709, W 146.4968
    describe "given leading cardinal prefixes" do
      context "separated by a comma" do
        let :input, do: "N 20.6709,W 146.4968"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([real: 20.6709, real: -146.4968]))
          expect (rest()) |> to(eq(""))
        end
      end

      context "separated by a comma and whitespace" do
        let :input, do: "N 20.6709, W 146.4968"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([real: 20.6709, real: -146.4968]))
          expect (rest()) |> to(eq(""))
        end
      end
    end

    # e.g. 20.6709 N, 146.4968 W
    describe "given trailing cardinal prefixes" do
      context "separated by a comma" do
        let :input, do: "20.6709 N,146.4968 W"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([{:real, 20.6709}, {:real, -146.4968}]))
          expect (rest()) |> to(eq(""))
        end
      end

      context "separated by a comma and whitespace" do
        let :input, do: "20.6709 N, 146.4968 W"
        it do
          expect (status()) |> to(eq(:ok))
          expect (acc()) |> to(eq([{:real, 20.6709}, {:real, -146.4968}]))
          expect (rest()) |> to(eq(""))
        end
      end
    end
  end
end
