defmodule Api.MediaTest do
  use Api.DataCase

  alias Api.Media

  describe "user_photos" do
    alias Api.Media.UserPhoto

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def user_photo_fixture(attrs \\ %{}) do
      {:ok, user_photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Media.create_user_photo()

      user_photo
    end

    test "list_user_photos/0 returns all user_photos" do
      user_photo = user_photo_fixture()
      assert Media.list_user_photos() == [user_photo]
    end

    test "get_user_photo!/1 returns the user_photo with given id" do
      user_photo = user_photo_fixture()
      assert Media.get_user_photo!(user_photo.id) == user_photo
    end

    test "create_user_photo/1 with valid data creates a user_photo" do
      assert {:ok, %UserPhoto{} = user_photo} = Media.create_user_photo(@valid_attrs)
      assert user_photo.url == "some url"
    end

    test "create_user_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_user_photo(@invalid_attrs)
    end

    test "update_user_photo/2 with valid data updates the user_photo" do
      user_photo = user_photo_fixture()
      assert {:ok, user_photo} = Media.update_user_photo(user_photo, @update_attrs)
      assert %UserPhoto{} = user_photo
      assert user_photo.url == "some updated url"
    end

    test "update_user_photo/2 with invalid data returns error changeset" do
      user_photo = user_photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_user_photo(user_photo, @invalid_attrs)
      assert user_photo == Media.get_user_photo!(user_photo.id)
    end

    test "delete_user_photo/1 deletes the user_photo" do
      user_photo = user_photo_fixture()
      assert {:ok, %UserPhoto{}} = Media.delete_user_photo(user_photo)
      assert_raise Ecto.NoResultsError, fn -> Media.get_user_photo!(user_photo.id) end
    end

    test "change_user_photo/1 returns a user_photo changeset" do
      user_photo = user_photo_fixture()
      assert %Ecto.Changeset{} = Media.change_user_photo(user_photo)
    end
  end

  describe "business_photos" do
    alias Api.Media.BusinessPhoto

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def business_photo_fixture(attrs \\ %{}) do
      {:ok, business_photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Media.create_business_photo()

      business_photo
    end

    test "list_business_photos/0 returns all business_photos" do
      business_photo = business_photo_fixture()
      assert Media.list_business_photos() == [business_photo]
    end

    test "get_business_photo!/1 returns the business_photo with given id" do
      business_photo = business_photo_fixture()
      assert Media.get_business_photo!(business_photo.id) == business_photo
    end

    test "create_business_photo/1 with valid data creates a business_photo" do
      assert {:ok, %BusinessPhoto{} = business_photo} = Media.create_business_photo(@valid_attrs)
      assert business_photo.url == "some url"
    end

    test "create_business_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_business_photo(@invalid_attrs)
    end

    test "update_business_photo/2 with valid data updates the business_photo" do
      business_photo = business_photo_fixture()
      assert {:ok, business_photo} = Media.update_business_photo(business_photo, @update_attrs)
      assert %BusinessPhoto{} = business_photo
      assert business_photo.url == "some updated url"
    end

    test "update_business_photo/2 with invalid data returns error changeset" do
      business_photo = business_photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_business_photo(business_photo, @invalid_attrs)
      assert business_photo == Media.get_business_photo!(business_photo.id)
    end

    test "delete_business_photo/1 deletes the business_photo" do
      business_photo = business_photo_fixture()
      assert {:ok, %BusinessPhoto{}} = Media.delete_business_photo(business_photo)
      assert_raise Ecto.NoResultsError, fn -> Media.get_business_photo!(business_photo.id) end
    end

    test "change_business_photo/1 returns a business_photo changeset" do
      business_photo = business_photo_fixture()
      assert %Ecto.Changeset{} = Media.change_business_photo(business_photo)
    end
  end
end
