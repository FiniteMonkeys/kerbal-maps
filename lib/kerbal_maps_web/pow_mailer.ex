defmodule KerbalMapsWeb.PowMailer do
  @moduledoc false

  use Pow.Phoenix.Mailer

  require Logger

  def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
    # Build email struct to be used in `process/1`

    %{to: user.email, subject: subject, text: text, html: html}
  end

  def process(email) do
    # Send email
    Logger.debug fn -> "E-mail sent: #{inspect email}" end
  end
end
