defmodule Nomada.Gallery do
  @moduledoc """
  The Gallery context for managing tattoo portfolio items.
  """

  import Ecto.Query, warn: false
  alias Nomada.Repo
  alias Nomada.Gallery.Tattoo

  @doc """
  Returns the list of tattoos with optional filtering.

  ## Options

    * `:category` - Filter by category ("Blackwork", "Neo-Traditional", "Dot-Work")
    * `:featured` - Filter by featured status (true/false)

  ## Examples

      iex> list_tattoos()
      [%Tattoo{}, ...]

      iex> list_tattoos(category: "Blackwork")
      [%Tattoo{category: "Blackwork"}, ...]

  """
  def list_tattoos(opts \\ []) do
    Tattoo
    |> filter_by_category(opts[:category])
    |> filter_by_featured(opts[:featured])
    |> filter_published()
    |> order_by_display_order()
    |> Repo.all()
  end

  @doc """
  Gets a single tattoo.

  Raises `Ecto.NoResultsError` if the Tattoo does not exist.

  ## Examples

      iex> get_tattoo!(123)
      %Tattoo{}

      iex> get_tattoo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tattoo!(id), do: Repo.get!(Tattoo, id)

  @doc """
  Creates a tattoo.

  ## Examples

      iex> create_tattoo(%{field: value})
      {:ok, %Tattoo{}}

      iex> create_tattoo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tattoo(attrs \\ %{}) do
    %Tattoo{}
    |> Tattoo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tattoo.

  ## Examples

      iex> update_tattoo(tattoo, %{field: new_value})
      {:ok, %Tattoo{}}

      iex> update_tattoo(tattoo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tattoo(%Tattoo{} = tattoo, attrs) do
    tattoo
    |> Tattoo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tattoo.

  ## Examples

      iex> delete_tattoo(tattoo)
      {:ok, %Tattoo{}}

      iex> delete_tattoo(tattoo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tattoo(%Tattoo{} = tattoo) do
    Repo.delete(tattoo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tattoo changes.

  ## Examples

      iex> change_tattoo(tattoo)
      %Ecto.Changeset{data: %Tattoo{}}

  """
  def change_tattoo(%Tattoo{} = tattoo, attrs \\ %{}) do
    Tattoo.changeset(tattoo, attrs)
  end

  # Private query helpers

  defp filter_by_category(query, nil), do: query

  defp filter_by_category(query, category) do
    where(query, [t], t.category == ^category)
  end

  defp filter_by_featured(query, nil), do: query

  defp filter_by_featured(query, featured) do
    where(query, [t], t.featured == ^featured)
  end

  defp filter_published(query) do
    where(query, [t], t.published == true)
  end

  defp order_by_display_order(query) do
    order_by(query, [t], [asc: t.display_order, desc: t.inserted_at])
  end
end
