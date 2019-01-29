defmodule KerbalMaps.CoordinateParser.Spec do
  @moduledoc false

  use ESpec

  doctest KerbalMaps.CoordinateParser

  example_group "parsing a coordinate pair" do
    let :parsed, do: input() |> KerbalMaps.CoordinateParser.parse

    # e.g. 20.6709, -146.4968
    describe "given a bare decimal pair" do
      context "separated by a comma" do
        let :input, do: "20.6709,-146.4968"
        it do: expect (parsed()) |> to(eq([20.6709, -146.4968]))
      end

      context "separated by whitespace" do
        let :input, do: "20.6709 146.4968"
        it do: expect (parsed()) |> to(eq([20.6709, 146.4968]))
      end

      context "separated by a comma and whitespace" do
        let :input, do: "-20.6709, 146.4968"
        it do: expect (parsed()) |> to(eq([-20.6709, 146.4968]))
      end
    end

    # e.g. N 20.6709, W 146.4968
    describe "given leading cardinal prefixes" do
      context "separated by a comma" do
        let :input, do: "N 20.6709,W 146.4968"
        it do: expect (parsed()) |> to(eq([20.6709, -146.4968]))
      end

      context "separated by a comma and whitespace" do
        let :input, do: "S 20.6709, E 146.4968"
        it do: expect (parsed()) |> to(eq([-20.6709, 146.4968]))
      end
    end

    # e.g. 20.6709 N, 146.4968 W
    describe "given trailing cardinal prefixes" do
      context "separated by a comma" do
        let :input, do: "20.6709 S,146.4968 E"
        it do: expect (parsed()) |> to(eq([-20.6709, 146.4968]))
      end

      context "separated by a comma and whitespace" do
        let :input, do: "20.6709 N, 146.4968 W"
        it do: expect (parsed()) |> to(eq([20.6709, -146.4968]))
      end
    end
  end
end
