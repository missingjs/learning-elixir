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
      {list, _id} = TaskList.add(TaskList.new(), "Buy milk")
      {list, _id2} = TaskList.add(list, "Buy bread")
      {list, _id3} = TaskList.add(list, "Buy eggs")
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
      assert [] = TaskList.all(TaskList.new())
    end

    test "returns tasks sorted by id" do
      {list, _} = TaskList.add(TaskList.new(), "a")
      {list, _} = TaskList.add(list, "b")
      {list, _} = TaskList.add(list, "c")

      assert [%Task{id: 1}, %Task{id: 2}, %Task{id: 3}] = TaskList.all(list)
    end
  end
end
