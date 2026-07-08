defmodule TodoTest do
  use ExUnit.Case, async: true

  alias Todo.{Task, TaskList}

  setup do
    {list, _} = TaskList.add(TaskList.new(), "a")
    {list, _} = TaskList.add(list, "b")
    %{task_list: list}
  end

  describe "command 'add' dispatching" do
    test "returns changed tuple with new task" do
      assert {:changed, new_list} = Todo.dispatch(TaskList.new(), "add", ["Buy milk"])
      assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(new_list, 1)
    end

    test "returns missing_argument error when no arguments" do
      assert {:error, :missing_argument} = Todo.dispatch(TaskList.new(), "add", [])
    end

    test "returns unknown_argument error when more than one arguments" do
      assert {:error, :unknown_argument} = Todo.dispatch(TaskList.new(), "add", ["a", "b"])
    end

    test "returns empty_title error when title is empty string" do
      assert {:error, :empty_title} = Todo.dispatch(TaskList.new(), "add", [""])
    end

    test "returns empty_title error when title only contains white space" do
      assert {:error, :empty_title} = Todo.dispatch(TaskList.new(), "add", ["  \n"])
    end
  end

  describe "command 'list' dispatching" do
    test "returns not_changed with same list", %{task_list: task_list} do
      assert {:not_changed, ^task_list} = Todo.dispatch(task_list, "list", [])
    end

    test "returns unknown_argument error when one or more arguments", %{task_list: task_list} do
      assert {:error, :unknown_argument} = Todo.dispatch(task_list, "list", ["a"])
      assert {:error, :unknown_argument} = Todo.dispatch(task_list, "list", ["a", "b"])
    end
  end

  describe "command 'get' dispatching" do
    test "get returns not_changed when task exists", %{task_list: task_list} do
      assert {:not_changed, ^task_list} = Todo.dispatch(task_list, "get", ["1"])
    end

    test "get returns task_not_found error when task not exists" do
      assert {:error, :task_not_found} = Todo.dispatch(TaskList.new(), "get", ["999"])
    end

    test "get returns invalid_task_id error when task id is not integer" do
      assert {:error, :invalid_task_id} = Todo.dispatch(TaskList.new(), "get", ["abc"])
    end

    test "returns missing_argument error when no arguments" do
      assert {:error, :missing_argument} = Todo.dispatch(TaskList.new(), "get", [])
    end

    test "returns unknown_argument error when more than one arguments" do
      assert {:error, :unknown_argument} = Todo.dispatch(TaskList.new(), "get", ["1", "2"])
    end
  end

  describe "command 'done' dispatching" do
    test "returns changed when task exists", %{task_list: task_list} do
      assert {:changed, new_task_list} = Todo.dispatch(task_list, "done", ["1"])
      assert {:ok, %Task{done: true}} = TaskList.fetch(new_task_list, 1)
    end

    test "returns task_not_found error when task not exists" do
      assert {:error, :task_not_found} = Todo.dispatch(TaskList.new(), "done", ["999"])
    end

    test "returns invalid_task_id error when task id is not integer" do
      assert {:error, :invalid_task_id} = Todo.dispatch(TaskList.new(), "done", ["abc"])
    end

    test "returns missing_argument error when no arguments" do
      assert {:error, :missing_argument} = Todo.dispatch(TaskList.new(), "done", [])
    end

    test "returns unknown_argument error when more than one arguments" do
      assert {:error, :unknown_argument} = Todo.dispatch(TaskList.new(), "done", ["1", "2"])
    end
  end

  describe "command 'remove' dispatching" do
    test "remove returns changed when task exists", %{task_list: task_list} do
      assert {:changed, new_task_list} = Todo.dispatch(task_list, "remove", ["1"])
      assert {:error, :not_found} = TaskList.fetch(new_task_list, 1)
    end

    test "returns task_not_found error when task not exists" do
      assert {:error, :task_not_found} = Todo.dispatch(TaskList.new(), "remove", ["999"])
    end

    test "returns invalid_task_id error when task id is not integer" do
      assert {:error, :invalid_task_id} = Todo.dispatch(TaskList.new(), "remove", ["abc"])
    end

    test "returns missing_argument error when no arguments" do
      assert {:error, :missing_argument} = Todo.dispatch(TaskList.new(), "remove", [])
    end

    test "returns unknown_argument error when more than one arguments" do
      assert {:error, :unknown_argument} = Todo.dispatch(TaskList.new(), "remove", ["1", "2"])
    end
  end
end
