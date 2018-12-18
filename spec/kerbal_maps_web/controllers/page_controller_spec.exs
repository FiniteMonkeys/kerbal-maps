defmodule KerbalMapsWeb.PageController.Spec do
  @moduledoc false

  use ESpec.Phoenix, controller: KerbalMapsWeb.PageController

  doctest KerbalMapsWeb.PageController

  example_group "GET /" do
    let :request, do: build_conn() |> get("/")

    it "returns all package names" do
      expect(html_response(request(), 200)) |> to(match("KerbalMaps"))
    end
  end
end
