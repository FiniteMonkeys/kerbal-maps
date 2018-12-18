ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(KerbalMaps.Repo)
  end

  config.finally fn(_shared) ->
    Ecto.Adapters.SQL.Sandbox.checkin(KerbalMaps.Repo, [])
  end
end

Code.require_file("spec/phoenix_helper.exs")
