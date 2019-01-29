defmodule KerbalMapsWeb.PageController.Spec do
  @moduledoc false

  use ESpec.Phoenix, controller: KerbalMapsWeb.PageController

  doctest KerbalMapsWeb.PageController

  example_group "GET /" do
    context "without a query string" do
      let :request, do: build_conn() |> get("/")
      let :response, do: html_response(request(), 200)

      it "returns a valid web page", do: expect(response()) |> to(match("<title>Kerbal Maps</title>"))
      it "does not set bodyFromQuery", do: expect(response()) |> to_not(match("<script>window.bodyFromQuery"))
      it "does not set locFromQuery", do: expect(response()) |> to_not(match("<script>window.locFromQuery"))
    end

    context "with a query string" do
      let :request, do: build_conn() |> get("/?body=Kerbin&loc=12.34,-56.78")
      let :response, do: html_response(request(), 200)

      it "returns a valid web page", do: expect(response()) |> to(match("<title>Kerbal Maps</title>"))
      it "sets bodyFromQuery", do: expect(response()) |> to(match("<script>window.bodyFromQuery"))
      it "sets locFromQuery", do: expect(response()) |> to(match("<script>window.locFromQuery"))
    end
  end
end
