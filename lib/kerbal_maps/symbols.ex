defmodule KerbalMaps.Symbols do
  @moduledoc """
  The Symbols context.
  """

  require Logger

  import Ecto.Query, warn: false

  alias KerbalMaps.Repo
  alias KerbalMaps.Symbols.Marker
  alias KerbalMaps.Users.User

  @doc """
  Returns the list of markers.

  ## Examples

      iex> list_markers()
      [%Marker{}, ...]

  """
  def list_markers(params \\ %{}) do
    params
    |> find_markers
    |> Repo.all
  end

  def list_markers_for_user(%User{} = user, params \\ %{}) do
    params
    |> Map.put("user_id", user.id)
    |> find_markers
    |> preload([:owner, :celestial_body])
    |> Repo.all
  end

  defp find_markers(params) do
    str = case params do
            %{"search" => %{"query" => s}} -> s
            _ -> nil
          end

    user_id = case params do
                %{"user_id" => v} when is_integer(v) -> v
                %{"user_id" => v} when is_binary(v) -> String.to_integer(v)
                _ -> nil
               end

    Marker
    |> filter_markers_by(:name, str)
    |> filter_markers_by(:user_id, user_id)
  end

  defp filter_markers_by(query, :name, str) when (is_nil(str) or (str == "")), do: query
  defp filter_markers_by(query, :name, str), do: query |> where([m], m.name == ^str)
  defp filter_markers_by(query, :user_id, nil), do: query
  defp filter_markers_by(query, :user_id, user_id), do: query |> where(fragment("user_id = ?", ^user_id))

  @doc """
  Gets a single marker.

  Raises `Ecto.NoResultsError` if the Marker does not exist.

  ## Examples

      iex> get_marker!(123)
      %Marker{}

      iex> get_marker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_marker!(id), do: Repo.get!(Marker, id)

  @doc """
  Creates a marker.

  ## Examples

      iex> create_marker(%{field: value})
      {:ok, %Marker{}}

      iex> create_marker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_marker(attrs \\ %{}) do
    %Marker{}
    |> Marker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a marker.

  ## Examples

      iex> update_marker(marker, %{field: new_value})
      {:ok, %Marker{}}

      iex> update_marker(marker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_marker(%Marker{} = marker, attrs) do
    marker
    |> Marker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Marker.

  ## Examples

      iex> delete_marker(marker)
      {:ok, %Marker{}}

      iex> delete_marker(marker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_marker(%Marker{} = marker) do
    Repo.delete(marker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking marker changes.

  ## Examples

      iex> change_marker(marker)
      %Ecto.Changeset{source: %Marker{}}

  """
  def change_marker(%Marker{} = marker) do
    Marker.changeset(marker, %{})
  end
end
