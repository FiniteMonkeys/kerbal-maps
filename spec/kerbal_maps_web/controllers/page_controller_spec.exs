defmodule KerbalMapsWeb.PageController.Spec do
  @moduledoc false

  use ESpec.Phoenix, controller: KerbalMapsWeb.PageController

  doctest KerbalMapsWeb.PageController

  example_group "GET /" do
    context "without a query string" do
      let :request, do: build_conn() |> get("/")

      it "returns all package names" do
        expect(html_response(request(), 200)) |> to(match("<title>Kerbal Maps</title>"))
      end
    end
  end
end
