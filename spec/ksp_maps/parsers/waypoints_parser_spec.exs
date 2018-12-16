defmodule KSPMaps.WaypointsParser.Spec do
  @moduledoc false

  use ESpec

  doctest KSPMaps.WaypointsParser

  example_group "parsing comments" do
    before do
      {:ok, stream_pid} = StringIO.open(input())
      {:shared, stream: stream_pid}
    end

    let :initial_data, do: []
    let :parsed, do: KSPMaps.WaypointsParser.parse_comment({:ok, initial_data(), shared.stream})
    let :status, do: parsed() |> elem(0)
    let :data, do: parsed() |> elem(1)
    let :remainder, do: parsed() |> elem(2)

    context "when eol-marker is :lf" do
      let :input, do: "// this is a comment" <> <<10>> <> "remainder"
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq(initial_data()))
        expect (remainder()) |> to(eq("remainder"))
      end
    end

    context "when eol-marker is :crlf" do
      let :input, do: "// this is a comment" <> <<13, 10>> <> "remainder"
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq(initial_data()))
        expect (remainder()) |> to(eq("remainder"))
      end
    end

    context "when eol-marker is :cr" do
      let :input, do: "// this is a comment" <> <<13>> <> "remainder"
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq(initial_data()))
        expect (remainder()) |> to(eq("remainder"))
      end
    end
  end
end
