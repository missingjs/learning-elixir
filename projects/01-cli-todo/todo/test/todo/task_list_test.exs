defmodule Todo.TaskListTest do
  use ExUnit.Case, async: true
  alias Todo.{Task, TaskList}

  describe "new/0" do
    test "returns an empty task list" do
      assert TaskList.new() == %TaskList{tasks: %{}, next_id: 1}
    end
  end

  describe "add/2" do
    test "assigns id 1 to the first task" do
      {list, id} = TaskList.add(TaskList.new(), "Buy milk")
      assert id == 1
      assert %TaskList{next_id: 2} = list
      assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(list, 1)
    end

    test "increments next_id on each add" do
      {list, _id} = TaskList.add(TaskList.new(), "Buy milk")
      {list, id2} = TaskList.add(list, "Buy bread")
      assert id2 == 2
      assert %TaskList{next_id: 3} = list
      assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(list, 1)
      assert {:ok, %Task{id: 2, title: "Buy bread", done: false}} = TaskList.fetch(list, 2)
    end
  end

  describe "fetch/2" do
    setup do
      {list, _} = TaskList.add(TaskList.new(), "Buy milk")
      {list, _} = TaskList.add(list, "Buy bread")
      {list, _} = TaskList.add(list, "Buy eggs")
      %{list: list}
    end

    test "returns the task when id exists", %{list: list} do
      assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(list, 1)
      assert {:ok, %Task{id: 2, title: "Buy bread", done: false}} = TaskList.fetch(list, 2)
      assert {:ok, %Task{id: 3, title: "Buy eggs", done: false}} = TaskList.fetch(list, 3)
    end

    test "returns :error tuple when id does not exist", %{list: list} do
      assert {:error, :not_found} = TaskList.fetch(list, 999)
    end

    test "returns :error tuple on empty list" do
      assert {:error, :not_found} = TaskList.fetch(TaskList.new(), 1)
    end
  end

  describe "all/1" do
    test "returns empty list when no tasks" do
      assert [] == TaskList.all(TaskList.new())
    end

    test "returns tasks sorted by id" do
      {list, _} = TaskList.add(TaskList.new(), "a")
      {list, _} = TaskList.add(list, "b")
      {list, _} = TaskList.add(list, "c")

      assert [%Task{id: 1}, %Task{id: 2}, %Task{id: 3}] = TaskList.all(list)
    end
  end

  describe "mark_done/2" do
    setup do
      {list, _} = TaskList.add(TaskList.new(), "a")
      {list, _} = TaskList.add(list, "b")
      {list, _} = TaskList.add(list, "c")
      %{list: list}
    end

    test "marks task as done when id exists", %{list: list} do
      {:ok, list} = TaskList.mark_done(list, 1)
      assert {:ok, %Task{id: 1, done: true}} = TaskList.fetch(list, 1)
    end

    test "other tasks remain unchanged", %{list: list} do
      {:ok, list} = TaskList.mark_done(list, 1)
      assert {:ok, %Task{id: 2, done: false}} = TaskList.fetch(list, 2)
      assert {:ok, %Task{id: 3, done: false}} = TaskList.fetch(list, 3)
    end

    test "is idempotent when marking a task as done", %{list: list} do
      {:ok, list} = TaskList.mark_done(list, 1)
      # mark done again
      {:ok, list} = TaskList.mark_done(list, 1)
      assert {:ok, %Task{id: 1, done: true}} = TaskList.fetch(list, 1)
    end

    test "mark a non-existing task as done", %{list: list} do
      assert {:error, :not_found} = TaskList.mark_done(list, 999)
    end

    test "mark a task in an empty task list" do
      assert {:error, :not_found} = TaskList.mark_done(TaskList.new(), 999)
    end
  end

  describe "remove/2" do
    setup do
      {list, _} = TaskList.add(TaskList.new(), "a")
      {list, _} = TaskList.add(list, "b")
      {list, _} = TaskList.add(list, "c")
      %{list: list}
    end

    test "removes task when id exists", %{list: list} do
      {:ok, list} = TaskList.remove(list, 1)
      assert {:error, :not_found} = TaskList.fetch(list, 1)
    end

    test "other tasks remain unchanged", %{list: list} do
      {:ok, list} = TaskList.remove(list, 1)
      assert {:ok, %Task{id: 2}} = TaskList.fetch(list, 2)
      assert {:ok, %Task{id: 3}} = TaskList.fetch(list, 3)
    end

    test "remove a non-existing task", %{list: list} do
      assert {:error, :not_found} = TaskList.remove(list, 999)
    end

    test "remove a task in an empty task list" do
      assert {:error, :not_found} = TaskList.remove(TaskList.new(), 999)
    end

    test "remove a task multiple times", %{list: list} do
      {:ok, list} = TaskList.remove(list, 1)
      assert {:error, :not_found} = TaskList.remove(list, 1)
    end

    test "next id is not affected by removing item", %{list: list} do
      {:ok, list} = TaskList.remove(list, 1)
      assert {_, 4} = TaskList.add(list, "x")
    end
  end

  describe "to_json/1" do
    setup do
      {list, _} = TaskList.add(TaskList.new(), "a")
      {list, _} = TaskList.add(list, "b")
      {list, _} = TaskList.add(list, "c")
      %{list: list}
    end

    test "encode to json map in happy path", %{list: list} do
      assert %{
               "tasks" => %{
                 "1" => %{"title" => "a"},
                 "2" => %{"title" => "b"},
                 "3" => %{"title" => "c"}
               },
               "next_id" => 4
             } = TaskList.to_json(list)
    end
  end

  describe "from_json/1" do
    test "parse from json map in happy path" do
      json_map = %{
        "tasks" => %{
          "1" => %{"id" => 1, "title" => "a", "done" => false},
          "2" => %{"id" => 2, "title" => "b", "done" => false},
          "3" => %{"id" => 3, "title" => "c", "done" => false}
        },
        "next_id" => 4
      }

      assert %TaskList{
               next_id: 4,
               tasks: %{
                 1 => %Task{title: "a"},
                 2 => %Task{title: "b"},
                 3 => %Task{title: "c"}
               }
             } = TaskList.from_json(json_map)
    end
  end
end
