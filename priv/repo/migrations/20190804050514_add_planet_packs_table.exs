defmodule KerbalMaps.Repo.Migrations.AddPlanetPacksTable do
  @moduledoc false

  use Ecto.Migration

  alias KerbalMaps.StaticData.PlanetPack

  def change do
    create table(:planet_packs) do
      add :name, :string, null: false
      add :description, :text, null: true
      add :url, :string, null: true
      timestamps()
    end

    flush()

    KerbalMaps.Repo.insert!(
      %PlanetPack{name: "(stock)"}
      |> PlanetPack.changeset(%{})
      |> Ecto.Changeset.apply_changes()
    )
  end
end
