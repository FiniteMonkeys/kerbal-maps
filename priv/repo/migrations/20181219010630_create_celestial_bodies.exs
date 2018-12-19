defmodule KerbalMaps.Repo.Migrations.CreateCelestialBodies do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:celestial_bodies) do
      add :name, :text, null: false
      add :parent_id, references(:celestial_bodies), null: true
      timestamps()
    end
  end
end
