defmodule KSPMapsWeb.PageController.Spec do
  @moduledoc false

  use ESpec.Phoenix, controller: KSPMapsWeb.PageController

  doctest KSPMapsWeb.PageController

  example_group "GET /" do
    let :request, do: build_conn() |> get("/")

    it "returns all package names" do
      expect(html_response(request(), 200)) |> to(match("KSPMaps"))
    end
  end
end
