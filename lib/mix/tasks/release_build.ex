defmodule Mix.Tasks.Release.Build do
  @moduledoc """
  A Mix task to build a release.

  There are a number of manual steps required to build a release.
  This should condense them into a single command.
  """

  use Mix.Task

  @shortdoc "Builds a release"
  def run(_command_line_args) do
    :os.cmd('mix deps.get --only prod') # Mix.Task.run ?
    :os.cmd('MIX_ENV=prod mix compile') # Mix.Task.run ?
    :os.cmd('cd assets && npx webpack --mode production')
    :os.cmd('mix phx.digest')           # Mix.Task.run ?
    :os.cmd('MIX_ENV=prod mix release') # Mix.Task.run ?
    # PORT=4000 _build/prod/rel/kerbal_maps/bin/kerbal_maps foreground
  end
end
