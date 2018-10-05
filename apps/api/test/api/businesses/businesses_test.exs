defmodule Api.BusinessesTest do
  use Api.DataCase

  alias Api.Businesses

  describe "businesses" do
    alias Api.Businesses.Business

    @valid_attrs %{long: "some long", name: "some name", short: "some short"}
    @update_attrs %{long: "some updated long", name: "some updated name", short: "some updated short"}
    @invalid_attrs %{long: nil, name: nil, short: nil}

    def business_fixture(attrs \\ %{}) do
      {:ok, business} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Businesses.create_business()

      business
    end

    test "list_businesses/0 returns all businesses" do
      business = business_fixture()
      assert Businesses.list_businesses() == [business]
    end

    test "get_business!/1 returns the business with given id" do
      business = business_fixture()
      assert Businesses.get_business!(business.id) == business
    end

    test "create_business/1 with valid data creates a business" do
      assert {:ok, %Business{} = business} = Businesses.create_business(@valid_attrs)
      assert business.long == "some long"
      assert business.name == "some name"
      assert business.short == "some short"
    end

    test "create_business/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Businesses.create_business(@invalid_attrs)
    end

    test "update_business/2 with valid data updates the business" do
      business = business_fixture()
      assert {:ok, business} = Businesses.update_business(business, @update_attrs)
      assert %Business{} = business
      assert business.long == "some updated long"
      assert business.name == "some updated name"
      assert business.short == "some updated short"
    end

    test "update_business/2 with invalid data returns error changeset" do
      business = business_fixture()
      assert {:error, %Ecto.Changeset{}} = Businesses.update_business(business, @invalid_attrs)
      assert business == Businesses.get_business!(business.id)
    end

    test "delete_business/1 deletes the business" do
      business = business_fixture()
      assert {:ok, %Business{}} = Businesses.delete_business(business)
      assert_raise Ecto.NoResultsError, fn -> Businesses.get_business!(business.id) end
    end

    test "change_business/1 returns a business changeset" do
      business = business_fixture()
      assert %Ecto.Changeset{} = Businesses.change_business(business)
    end
  end

  describe "categories" do
    alias Api.Businesses.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Businesses.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Businesses.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Businesses.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Businesses.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Businesses.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Businesses.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Businesses.update_category(category, @invalid_attrs)
      assert category == Businesses.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Businesses.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Businesses.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Businesses.change_category(category)
    end
  end

  describe "broadcasts" do
    alias Api.Businesses.Broadcast

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def broadcast_fixture(attrs \\ %{}) do
      {:ok, broadcast} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Businesses.create_broadcast()

      broadcast
    end

    test "list_broadcasts/0 returns all broadcasts" do
      broadcast = broadcast_fixture()
      assert Businesses.list_broadcasts() == [broadcast]
    end

    test "get_broadcast!/1 returns the broadcast with given id" do
      broadcast = broadcast_fixture()
      assert Businesses.get_broadcast!(broadcast.id) == broadcast
    end

    test "create_broadcast/1 with valid data creates a broadcast" do
      assert {:ok, %Broadcast{} = broadcast} = Businesses.create_broadcast(@valid_attrs)
      assert broadcast.text == "some text"
    end

    test "create_broadcast/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Businesses.create_broadcast(@invalid_attrs)
    end

    test "update_broadcast/2 with valid data updates the broadcast" do
      broadcast = broadcast_fixture()
      assert {:ok, broadcast} = Businesses.update_broadcast(broadcast, @update_attrs)
      assert %Broadcast{} = broadcast
      assert broadcast.text == "some updated text"
    end

    test "update_broadcast/2 with invalid data returns error changeset" do
      broadcast = broadcast_fixture()
      assert {:error, %Ecto.Changeset{}} = Businesses.update_broadcast(broadcast, @invalid_attrs)
      assert broadcast == Businesses.get_broadcast!(broadcast.id)
    end

    test "delete_broadcast/1 deletes the broadcast" do
      broadcast = broadcast_fixture()
      assert {:ok, %Broadcast{}} = Businesses.delete_broadcast(broadcast)
      assert_raise Ecto.NoResultsError, fn -> Businesses.get_broadcast!(broadcast.id) end
    end

    test "change_broadcast/1 returns a broadcast changeset" do
      broadcast = broadcast_fixture()
      assert %Ecto.Changeset{} = Businesses.change_broadcast(broadcast)
    end
  end

  describe "operators" do
    alias Api.Businesses.Operator

    @valid_attrs %{is_admin: true}
    @update_attrs %{is_admin: false}
    @invalid_attrs %{is_admin: nil}

    def operator_fixture(attrs \\ %{}) do
      {:ok, operator} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Businesses.create_operator()

      operator
    end

    test "list_operators/0 returns all operators" do
      operator = operator_fixture()
      assert Businesses.list_operators() == [operator]
    end

    test "get_operator!/1 returns the operator with given id" do
      operator = operator_fixture()
      assert Businesses.get_operator!(operator.id) == operator
    end

    test "create_operator/1 with valid data creates a operator" do
      assert {:ok, %Operator{} = operator} = Businesses.create_operator(@valid_attrs)
      assert operator.is_admin == true
    end

    test "create_operator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Businesses.create_operator(@invalid_attrs)
    end

    test "update_operator/2 with valid data updates the operator" do
      operator = operator_fixture()
      assert {:ok, operator} = Businesses.update_operator(operator, @update_attrs)
      assert %Operator{} = operator
      assert operator.is_admin == false
    end

    test "update_operator/2 with invalid data returns error changeset" do
      operator = operator_fixture()
      assert {:error, %Ecto.Changeset{}} = Businesses.update_operator(operator, @invalid_attrs)
      assert operator == Businesses.get_operator!(operator.id)
    end

    test "delete_operator/1 deletes the operator" do
      operator = operator_fixture()
      assert {:ok, %Operator{}} = Businesses.delete_operator(operator)
      assert_raise Ecto.NoResultsError, fn -> Businesses.get_operator!(operator.id) end
    end

    test "change_operator/1 returns a operator changeset" do
      operator = operator_fixture()
      assert %Ecto.Changeset{} = Businesses.change_operator(operator)
    end
  end

  describe "events" do
    alias Api.Businesses.Event

    @valid_attrs %{deleted: true, from_id: "some from_id", text: "some text", to_id: "some to_id", type: "some type"}
    @update_attrs %{deleted: false, from_id: "some updated from_id", text: "some updated text", to_id: "some updated to_id", type: "some updated type"}
    @invalid_attrs %{deleted: nil, from_id: nil, text: nil, to_id: nil, type: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Businesses.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Businesses.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Businesses.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Businesses.create_event(@valid_attrs)
      assert event.deleted == true
      assert event.from_id == "some from_id"
      assert event.text == "some text"
      assert event.to_id == "some to_id"
      assert event.type == "some type"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Businesses.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Businesses.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.deleted == false
      assert event.from_id == "some updated from_id"
      assert event.text == "some updated text"
      assert event.to_id == "some updated to_id"
      assert event.type == "some updated type"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Businesses.update_event(event, @invalid_attrs)
      assert event == Businesses.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Businesses.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Businesses.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Businesses.change_event(event)
    end
  end
end
