defmodule KerbalMaps.Symbols.Marker do
  @moduledoc """
  The Marker schema.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import ESpec.Testable

  alias KerbalMaps.StaticData.CelestialBody
  alias KerbalMaps.Users.User

  schema "markers" do
    field :altitude, :decimal
    field :description, :string
    field :icon_name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :navigation_uuid, Ecto.UUID

    belongs_to :owner, User, foreign_key: :user_id
    belongs_to :celestial_body, CelestialBody

    timestamps()
  end

  @doc false
  def changeset(marker, attrs) do
    marker
    |> cast(attrs, [:name, :description, :latitude, :longitude, :altitude, :navigation_uuid, :icon_name, :user_id, :celestial_body_id])
    |> validate_required([:name, :latitude, :longitude, :user_id, :celestial_body_id])
    |> unsafe_validate_unique([:navigation_uuid], KerbalMaps.Repo)
    |> unique_constraint(:navigation_uuid)
    |> wrap([:latitude], {-90.000000, 90.000000})
    |> wrap([:longitude], {-180.000000, 180.000000})
  end

  def clamp(changeset, fields, {_min, _max} = range) do
    Enum.reduce(fields, changeset, fn field, cs ->
      put_change(cs, field, clamp(get_field(cs, field), range))
    end)
  end

  defp_testable clamp(nil, _), do: nil
  defp_testable clamp(%Decimal{} = value, {%Decimal{} = min, %Decimal{} = max}), do: value |> Decimal.max(min) |> Decimal.min(max)
  defp_testable clamp(%Decimal{} = value, {min, %Decimal{} = max}) when is_float(min), do: clamp(value, {Decimal.from_float(min), max})
  defp_testable clamp(%Decimal{} = value, {%Decimal{} = min, max}) when is_float(max), do: clamp(value, {min, Decimal.from_float(max)})
  defp_testable clamp(%Decimal{} = value, {min, max}) when is_float(min), do: clamp(value, {Decimal.from_float(min), max})
  defp_testable clamp(%Decimal{} = value, {min, %Decimal{} = max}), do: clamp(value, {Decimal.new(min), max})
  defp_testable clamp(%Decimal{} = value, {%Decimal{} = min, max}), do: clamp(value, {min, Decimal.new(max)})
  defp_testable clamp(%Decimal{} = value, {min, max}), do: clamp(value, {Decimal.new(min), max})
  defp_testable clamp(value, {min, _max}) when (value < min), do: min
  defp_testable clamp(value, {_min, max}) when (value > max), do: max
  defp_testable clamp(value, _), do: value

  def wrap(changeset, fields, {_min, _max} = range) do
    Enum.reduce(fields, changeset, fn field, cs ->
      put_change(cs, field, wrap(get_field(cs, field), range))
    end)
  end

  defp_testable wrap(nil, _), do: nil
  defp_testable wrap(%Decimal{} = value, {%Decimal{} = min, %Decimal{} = max}) do
    cond do
      Decimal.cmp(value, min) == :lt -> value |> Decimal.add(max) |> Decimal.sub(min)
      Decimal.cmp(value, max) == :gt -> value |> Decimal.add(min) |> Decimal.sub(max)
      true -> value
    end
  end
  defp_testable wrap(%Decimal{} = value, {min, %Decimal{} = max}) when is_float(min), do: wrap(value, {Decimal.from_float(min), max})
  defp_testable wrap(%Decimal{} = value, {%Decimal{} = min, max}) when is_float(max), do: wrap(value, {min, Decimal.from_float(max)})
  defp_testable wrap(%Decimal{} = value, {min, max}) when is_float(min), do: wrap(value, {Decimal.from_float(min), max})
  defp_testable wrap(%Decimal{} = value, {min, %Decimal{} = max}), do: wrap(value, {Decimal.new(min), max})
  defp_testable wrap(%Decimal{} = value, {%Decimal{} = min, max}), do: wrap(value, {min, Decimal.new(max)})
  defp_testable wrap(%Decimal{} = value, {min, max}), do: wrap(value, {Decimal.new(min), max})
  defp_testable wrap(value, {min, max}) when (value < min), do: value + max - min
  defp_testable wrap(value, {min, max}) when (value > max), do: value + min - max
  defp_testable wrap(value, _), do: value

end
