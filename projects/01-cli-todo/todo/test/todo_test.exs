defmodule TodoTest do
  use ExUnit.Case, async: true

  alias Todo.{Task, TaskList}

  setup do
    {list, _} = TaskList.add(TaskList.new(), "a")
    {list, _} = TaskList.add(list, "b")
    %{task_list: list}
  end

  test "add returns changed tuple with new task" do
    task_list = TaskList.new()
    assert {:changed, new_list} = Todo.dispatch(task_list, "add", ["Buy milk"])
    assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(new_list, 1)
  end

  test "list returns not_changed with same list", %{task_list: task_list} do
    assert {:not_changed, ^task_list} = Todo.dispatch(task_list, "list", [])
  end

  test "get returns not_changed when task exists", %{task_list: task_list} do
    assert {:not_changed, ^task_list} = Todo.dispatch(task_list, "get", ["1"])
  end

  test "get returns task_not_found error when task not exists" do
    assert {:error, :task_not_found} = Todo.dispatch(TaskList.new(), "get", ["999"])
  end

  test "get returns invalid_task_id error when task id is not integer" do
    assert {:error, :invalid_task_id} = Todo.dispatch(TaskList.new(), "get", ["abc"])
  end

  test "done returns changed when task exists", %{task_list: task_list} do
    assert {:changed, new_task_list} = Todo.dispatch(task_list, "done", ["1"])
    assert {:ok, %Task{done: true}} = TaskList.fetch(new_task_list, 1)
  end

  test "remove returns changed when task exists", %{task_list: task_list} do
    assert {:changed, new_task_list} = Todo.dispatch(task_list, "remove", ["1"])
    assert {:error, :not_found} = TaskList.fetch(new_task_list, 1)
  end

  test "done returns task_not_found error when task not exists" do
    assert {:error, :task_not_found} = Todo.dispatch(TaskList.new(), "done", ["999"])
  end

  test "done returns invalid_task_id error when task id is not integer" do
    assert {:error, :invalid_task_id} = Todo.dispatch(TaskList.new(), "done", ["abc"])
  end

  test "remove returns task_not_found error when task not exists" do
    assert {:error, :task_not_found} = Todo.dispatch(TaskList.new(), "remove", ["999"])
  end

  test "remove returns invalid_task_id error when task id is not integer" do
    assert {:error, :invalid_task_id} = Todo.dispatch(TaskList.new(), "remove", ["abc"])
  end
end
