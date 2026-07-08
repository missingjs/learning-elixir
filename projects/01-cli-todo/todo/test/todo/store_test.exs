defmodule Todo.StoreTest do
  use ExUnit.Case, async: true

  alias Todo.{Store, Task, TaskList}

  setup do
    temp_file = Path.join(System.tmp_dir!(), "todo_store_test_#{System.unique_integer()}.json")

    on_exit(fn ->
      if File.exists?(temp_file), do: File.rm!(temp_file)
    end)

    {:ok, temp_file: temp_file}
  end

  test "load!/1 returns empty list when file does not exist", %{temp_file: temp_file} do
    assert %TaskList{tasks: %{}, next_id: 1} = Store.load!(temp_file)
  end

  test "round-trip: save then load", %{temp_file: temp_file} do
    task_list = TaskList.new()
    {task_list, _id} = TaskList.add(task_list, "Buy milk")

    Store.save!(temp_file, task_list)
    loaded = Store.load!(temp_file)

    assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(loaded, 1)
  end
end
