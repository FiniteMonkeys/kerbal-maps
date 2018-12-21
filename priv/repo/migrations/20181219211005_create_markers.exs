defmodule KerbalMaps.Repo.Migrations.CreateMarkers do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:markers) do
      add :name, :string, null: false
      add :description, :text
      add :latitude, :decimal, null: false
      add :longitude, :decimal, null: false
      add :altitude, :decimal
      add :navigation_uuid, :uuid
      add :icon_name, :string
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :celestial_body_id, references(:celestial_bodies, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:markers, [:user_id])
    create index(:markers, [:celestial_body_id])
  end
end
