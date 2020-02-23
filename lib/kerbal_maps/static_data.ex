defmodule KerbalMaps.StaticData do
  @moduledoc """
  The StaticData context.
  """

  require Logger

  import Ecto.Query, warn: false

  alias KerbalMaps.Repo
  alias KerbalMaps.StaticData.{CelestialBody, PlanetPack}

  @doc """
  Returns the list of celestial_bodies.

  ## Examples

      iex> list_celestial_bodies()
      [%CelestialBody{}, ...]

  """
  def list_celestial_bodies(params \\ %{}) do
    find_celestial_bodies(params)
    |> Repo.all()
  end

  def find_celestial_body_by_name(name) do
    %{"search" => %{"query" => name}}
    |> find_celestial_bodies
    |> Repo.one!()
  end

  defp find_celestial_bodies(params) do
    str =
      case params do
        %{"search" => %{"query" => s}} -> s
        _ -> nil
      end

    CelestialBody
    |> filter_celestial_bodies_by(:name, str)
  end

  defp filter_celestial_bodies_by(query, :name, str) when is_nil(str) or str == "", do: query

  defp filter_celestial_bodies_by(query, :name, str),
    do: query |> where(fragment("lower(name) = lower(?)", ^str))

  @doc """
  Gets a single celestial_body.

  Raises `Ecto.NoResultsError` if the Celestial body does not exist.

  ## Examples

      iex> get_celestial_body!(123)
      %CelestialBody{}

      iex> get_celestial_body!(456)
      ** (Ecto.NoResultsError)

  """
  def get_celestial_body!(id), do: Repo.get!(CelestialBody, id)

  @doc """
  Creates a celestial_body.

  ## Examples

      iex> create_celestial_body(%{field: value})
      {:ok, %CelestialBody{}}

      iex> create_celestial_body(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_celestial_body(attrs \\ %{}) do
    %CelestialBody{}
    |> CelestialBody.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a celestial_body.

  ## Examples

      iex> update_celestial_body(celestial_body, %{field: new_value})
      {:ok, %CelestialBody{}}

      iex> update_celestial_body(celestial_body, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_celestial_body(%CelestialBody{} = celestial_body, attrs) do
    celestial_body
    |> CelestialBody.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CelestialBody.

  ## Examples

      iex> delete_celestial_body(celestial_body)
      {:ok, %CelestialBody{}}

      iex> delete_celestial_body(celestial_body)
      {:error, %Ecto.Changeset{}}

  """
  def delete_celestial_body(%CelestialBody{} = celestial_body) do
    Repo.delete(celestial_body)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking celestial_body changes.

  ## Examples

      iex> change_celestial_body(celestial_body)
      %Ecto.Changeset{source: %CelestialBody{}}

  """
  def change_celestial_body(%CelestialBody{} = celestial_body) do
    CelestialBody.changeset(celestial_body, %{})
  end

  @doc """
  Returns the list of planet_packs.

  ## Examples

      iex> list_planet_packs()
      [%PlanetPack{}, ...]

  """
  def list_planet_packs(params \\ %{}) do
    find_planet_packs(params)
    |> Repo.all()
  end

  def find_planet_pack_by_name(name) do
    %{"search" => %{"query" => name}}
    |> find_planet_packs
    |> Repo.one!()
  end

  defp find_planet_packs(params) do
    str =
      case params do
        %{"search" => %{"query" => s}} -> s
        _ -> nil
      end

    PlanetPack
    |> filter_planet_packs_by(:name, str)
  end

  defp filter_planet_packs_by(query, :name, str) when is_nil(str) or str == "", do: query

  defp filter_planet_packs_by(query, :name, str),
    do: query |> where(fragment("lower(name) = lower(?)", ^str))

  @doc """
  Gets a single planet_pack.

  Raises `Ecto.NoResultsError` if the planet pack does not exist.

  ## Examples

      iex> get_planet_pack!(123)
      %PlanetPack{}

      iex> get_planet_pack!(456)
      ** (Ecto.NoResultsError)

  """
  def get_planet_pack!(id), do: Repo.get!(PlanetPack, id)

  @doc """
  Creates a planet_pack.

  ## Examples

      iex> create_planet_pack(%{field: value})
      {:ok, %PlanetPack{}}

      iex> create_planet_pack(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_planet_pack(attrs \\ %{}) do
    %PlanetPack{}
    |> PlanetPack.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a planet_pack.

  ## Examples

      iex> update_planet_pack(planet_pack, %{field: new_value})
      {:ok, %PlanetPack{}}

      iex> update_planet_pack(planet_pack, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_planet_pack(%PlanetPack{} = planet_pack, attrs) do
    planet_pack
    |> PlanetPack.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PlanetPack.

  ## Examples

      iex> delete_planet_pack(planet_pack)
      {:ok, %PlanetPack{}}

      iex> delete_planet_pack(planet_pack)
      {:error, %Ecto.Changeset{}}

  """
  def delete_planet_pack(%PlanetPack{} = planet_pack) do
    Repo.delete(planet_pack)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking planet_pack changes.

  ## Examples

      iex> change_planet_pack(planet_pack)
      %Ecto.Changeset{source: %PlanetPack{}}

  """
  def change_planet_pack(%PlanetPack{} = planet_pack) do
    PlanetPack.changeset(planet_pack, %{})
  end
end
