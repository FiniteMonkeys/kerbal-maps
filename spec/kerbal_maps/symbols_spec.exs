defmodule KerbalMaps.Symbols.Spec do
  @moduledoc false

  use ESpec

  require Logger

  import KerbalMaps.Factory

  alias KerbalMaps.Repo
  alias KerbalMaps.Symbols
  # alias KerbalMaps.Symbols.Marker

  # doctest KerbalMaps.Symbols

  example_group "markers" do
    describe "list_markers/1" do
      before do: allow Repo |> to(accept(:all, fn(_) -> static_list() end))
      let :static_list, do: [build(:marker)]
      let :all_markers, do: Symbols.list_markers()

      it do: expect (all_markers()) |> to(have_count(Enum.count(static_list())))
      it do: expect (all_markers()) |> to(match_list(static_list()))
    end
  end

  example_group "overlays" do
    describe "list_overlays/1" do
      before do: allow Repo |> to(accept(:all, fn(_) -> static_list() end))
      let :static_list, do: [build(:overlay)]
      let :all_overlays, do: Symbols.list_overlays()

      it do: expect (all_overlays()) |> to(have_count(Enum.count(static_list())))
      it do: expect (all_overlays()) |> to(match_list(static_list()))
    end
  end
end
