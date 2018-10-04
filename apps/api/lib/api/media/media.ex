defmodule Api.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Media.UserPhoto

  @doc """
  Returns the list of user_photos.

  ## Examples

      iex> list_user_photos()
      [%UserPhoto{}, ...]

  """
  def list_user_photos do
    Repo.all(UserPhoto)
  end

  @doc """
  Gets a single user_photo.

  Raises `Ecto.NoResultsError` if the User photo does not exist.

  ## Examples

      iex> get_user_photo!(123)
      %UserPhoto{}

      iex> get_user_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_photo!(id), do: Repo.get!(UserPhoto, id)

  @doc """
  Creates a user_photo.

  ## Examples

      iex> create_user_photo(%{field: value})
      {:ok, %UserPhoto{}}

      iex> create_user_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_photo(attrs \\ %{}) do
    %UserPhoto{}
    |> UserPhoto.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_photo.

  ## Examples

      iex> update_user_photo(user_photo, %{field: new_value})
      {:ok, %UserPhoto{}}

      iex> update_user_photo(user_photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_photo(%UserPhoto{} = user_photo, attrs) do
    user_photo
    |> UserPhoto.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserPhoto.

  ## Examples

      iex> delete_user_photo(user_photo)
      {:ok, %UserPhoto{}}

      iex> delete_user_photo(user_photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_photo(%UserPhoto{} = user_photo) do
    Repo.delete(user_photo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_photo changes.

  ## Examples

      iex> change_user_photo(user_photo)
      %Ecto.Changeset{source: %UserPhoto{}}

  """
  def change_user_photo(%UserPhoto{} = user_photo) do
    UserPhoto.changeset(user_photo, %{})
  end

  alias Api.Media.BusinessPhoto

  @doc """
  Returns the list of business_photos.

  ## Examples

      iex> list_business_photos()
      [%BusinessPhoto{}, ...]

  """
  def list_business_photos do
    Repo.all(BusinessPhoto)
  end

  @doc """
  Gets a single business_photo.

  Raises `Ecto.NoResultsError` if the Business photo does not exist.

  ## Examples

      iex> get_business_photo!(123)
      %BusinessPhoto{}

      iex> get_business_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_business_photo!(id), do: Repo.get!(BusinessPhoto, id)

  @doc """
  Creates a business_photo.

  ## Examples

      iex> create_business_photo(%{field: value})
      {:ok, %BusinessPhoto{}}

      iex> create_business_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_business_photo(attrs \\ %{}) do
    %BusinessPhoto{}
    |> BusinessPhoto.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a business_photo.

  ## Examples

      iex> update_business_photo(business_photo, %{field: new_value})
      {:ok, %BusinessPhoto{}}

      iex> update_business_photo(business_photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_business_photo(%BusinessPhoto{} = business_photo, attrs) do
    business_photo
    |> BusinessPhoto.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BusinessPhoto.

  ## Examples

      iex> delete_business_photo(business_photo)
      {:ok, %BusinessPhoto{}}

      iex> delete_business_photo(business_photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_business_photo(%BusinessPhoto{} = business_photo) do
    Repo.delete(business_photo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business_photo changes.

  ## Examples

      iex> change_business_photo(business_photo)
      %Ecto.Changeset{source: %BusinessPhoto{}}

  """
  def change_business_photo(%BusinessPhoto{} = business_photo) do
    BusinessPhoto.changeset(business_photo, %{})
  end
end
