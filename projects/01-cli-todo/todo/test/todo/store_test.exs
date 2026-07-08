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

  test "round-trip: save then load", %{temp_file: temp_file} do
    task_list = TaskList.new()
    {task_list, _id} = TaskList.add(task_list, "Buy milk")

    Store.save!(temp_file, task_list)
    {:ok, loaded} = Store.load(temp_file)

    assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(loaded, 1)
  end

  describe "load/1" do
    test "returns TaskList with valid input", %{temp_file: temp_file} do
      File.write!(temp_file, """
        {"tasks": {"1": {"id": 1, "title": "Buy milk", "done": false}}, "next_id": 1}
      """)

      {:ok, loaded} = Store.load(temp_file)

      assert {:ok, %Task{id: 1, title: "Buy milk", done: false}} = TaskList.fetch(loaded, 1)
    end

    test "returns empty task list when file not found" do
      assert {:ok, %TaskList{next_id: 1, tasks: %{}}} = Store.load(".file_that_not_exists")
    end

    test "returns error if file is not readable" do
      assert {:error, _reason} = Store.load(System.tmp_dir!())
    end

    test "returns json decode error when input file is empty", %{temp_file: temp_file} do
      File.write!(temp_file, "")
      assert {:error, %Jason.DecodeError{}} = Store.load(temp_file)
    end

    test "returns json decode error when input file contains malformed json", %{
      temp_file: temp_file
    } do
      File.write!(temp_file, """
        {"abc": def
      """)

      assert {:error, %Jason.DecodeError{}} = Store.load(temp_file)
    end
  end
end
