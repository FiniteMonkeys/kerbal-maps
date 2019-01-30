defmodule KerbalMaps.CoordinateParser.Spec do
  @moduledoc false

  use ESpec

  doctest KerbalMaps.CoordinateParser

  example_group "incomplete or improperly formatted input" do
    let :parsed, do: input() |> KerbalMaps.CoordinateParser.parse

    describe "given something entirely unlike a coordinate pair" do
      let :input, do: "It was the best of times, it was the worst of times"
      it do: expect(parsed() |> elem(0)) |> to(eq(:error))
    end

    describe "given incomplete data" do
      let :input, do: "20.6709"
      it do: expect(parsed() |> elem(0)) |> to(eq(:error))
    end

    describe "given bad cardinal directions" do
      let :input, do: "M 20.6709, W 146.4968"
      it do: expect(parsed() |> elem(0)) |> to(eq(:error))
    end

    describe "given cardinal directions and signed values" do
      let :input, do: "N 20.6709, E -146.4968"
      it do: expect(parsed() |> elem(0)) |> to(eq(:error))
    end
  end

  example_group "parsing a coordinate pair" do
    let :parsed, do: input() |> KerbalMaps.CoordinateParser.parse

    # e.g. 20.6709, -146.4968
    describe "given a bare decimal pair" do
      context "separated by a comma" do
        let :input, do: "20.6709,-146.4968"
        it do: expect(parsed()) |> to(eq([20.6709, -146.4968]))
      end

      context "separated by whitespace" do
        let :input, do: "20.6709 146.4968"
        it do: expect(parsed()) |> to(eq([20.6709, 146.4968]))
      end

      context "separated by a comma and whitespace" do
        let :input, do: "-20.6709, 146.4968"
        it do: expect(parsed()) |> to(eq([-20.6709, 146.4968]))
      end
    end

    # e.g. N 20.6709, W 146.4968
    describe "given leading cardinal prefixes" do
      context "separated by a comma" do
        let :input, do: "N 20.6709,W 146.4968"
        it do: expect(parsed()) |> to(eq([20.6709, -146.4968]))
      end

      context "separated by a comma and whitespace" do
        let :input, do: "S 20.6709, E 146.4968"
        it do: expect(parsed()) |> to(eq([-20.6709, 146.4968]))
      end
    end

    # e.g. 20.6709 N, 146.4968 W
    describe "given trailing cardinal prefixes" do
      context "separated by a comma" do
        let :input, do: "20.6709 S,146.4968 E"
        it do: expect(parsed()) |> to(eq([-20.6709, 146.4968]))
      end

      context "separated by a comma and whitespace" do
        let :input, do: "20.6709 N, 146.4968 W"
        it do: expect(parsed()) |> to(eq([20.6709, -146.4968]))
      end
    end
  end
end
