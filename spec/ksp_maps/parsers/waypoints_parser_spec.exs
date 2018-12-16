defmodule KSPMaps.WaypointsParser.Spec do
  @moduledoc false

  use ESpec

  doctest KSPMaps.WaypointsParser

  example_group "parsing a single waypoint" do
    before do
      {:ok, stream_pid} = StringIO.open(input())
      {:shared, stream: stream_pid}
    end

    let :initial_data, do: []
    let :parsed, do: KSPMaps.WaypointsParser.parse_waypoint({:ok, initial_data(), "", shared.stream})
    let :status, do: parsed() |> elem(0)
    let :data, do: parsed() |> elem(1) |> List.flatten
    let :remainder, do: parsed() |> elem(2)

    context "given single-line input" do
      let :input, do: "{ name = foo } remainder"
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"name" => "foo"}]))
        expect (remainder()) |> to(eq("remainder"))
      end
    end

    context "given multi-line input" do
      let :input, do: """
      {
        name = bar
      }
      remainder
      """
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"name" => "bar"}]))
        expect (remainder()) |> to(eq("remainder\n"))
      end
    end

    context "given multiple pairs in the input" do
      let :input, do: """
      {
        name = baz
        foo = bar
      }
      remainder
      """
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"foo" => "bar", "name" => "baz"}]))
        expect (remainder()) |> to(eq("remainder\n"))
      end
    end
  end

  example_group "parsing example data" do
    before do
      {:ok, stream_pid} = StringIO.open(input())
      {:shared, stream: stream_pid}
    end

    let :initial_data, do: []
    let :parsed, do: KSPMaps.WaypointsParser.parse({:ok, initial_data(), shared.stream})
    let :status, do: parsed() |> elem(0)
    let :data, do: parsed() |> elem(1) |> List.flatten
    let :remainder, do: parsed() |> elem(2)

    context "with a single waypoint" do
      let :input, do: """
      WAYPOINT
      {
        name = The Great Quux
      	celestialName = Kerbin
      }
      """
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"name" => "The Great Quux", "celestialName" => "Kerbin"}]))
        expect (remainder()) |> to(eq(""))
      end
    end

    context "with multiple waypoints" do
      let :input, do: """
      WAYPOINT
      {
        name = The Great Quux
      	celestialName = Kerbin
      }
      WAYPOINT
      {
        name = The Northern Wibble
      	celestialName = Mun
      }
      """
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"name" => "The Great Quux", "celestialName" => "Kerbin"}, %{"name" => "The Northern Wibble", "celestialName" => "Mun"}]))
        expect (remainder()) |> to(eq(""))
      end
    end

    context "with a leading comment" do
      let :input, do: """
      // Waypoint Manager Custom Waypoints File
      //
      // This file contains an extract of Waypoint Manager custom waypoints.
      WAYPOINT
      {
        name = The Great Quux
      	celestialName = Kerbin
      }
      WAYPOINT
      {
        name = The Northern Wibble
      	celestialName = Mun
      }
      """
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"name" => "The Great Quux", "celestialName" => "Kerbin"}, %{"name" => "The Northern Wibble", "celestialName" => "Mun"}]))
        expect (remainder()) |> to(eq(""))
      end
    end

    context "with an embedded comment" do
      let :input, do: """
      // Waypoints on Kerbin
      WAYPOINT
      {
        name = The Great Quux
      	celestialName = Kerbin
      }

      // Waypoints on Mun
      WAYPOINT
      {
        name = The Northern Wibble
      	celestialName = Mun
      }
      """
      it do
        expect (status()) |> to(eq(:ok))
        expect (data()) |> to(eq([%{"name" => "The Great Quux", "celestialName" => "Kerbin"}, %{"name" => "The Northern Wibble", "celestialName" => "Mun"}]))
        expect (remainder()) |> to(eq(""))
      end
    end
  end

  example_group "stripping a comment" do
    before do
      {:ok, stream_pid} = StringIO.open(input())
      {:shared, stream: stream_pid}
    end

    let :initial_data, do: []
    let :parsed, do: KSPMaps.WaypointsParser.strip_comment({:ok, initial_data(), "", shared.stream})
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
