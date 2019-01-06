defmodule ESpec.Testable do
  @moduledoc """
  Borrowed shamelessly from https://github.com/wistia/ex_ex/blob/master/lib/ex_ex/ex_unit.ex
  """
  defmacro __using__(_opts) do
    quote do
      import ESpec.Testable
    end
  end

  @doc """
  Makes a function public when it's compiled for a test environment and private otherwise. This is
  useful, for example, to test library functions that shouldn't be exported to client apps.
  """
  defmacro defp_testable(head, body \\ nil) do
    if Mix.env() == :test do
      quote do
        def unquote(head) do
          unquote(body[:do])
        end
      end
    else
      quote do
        defp unquote(head) do
          unquote(body[:do])
        end
      end
    end
  end
end
