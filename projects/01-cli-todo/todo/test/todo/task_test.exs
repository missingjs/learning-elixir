defmodule Todo.TaskTest do
  use ExUnit.Case, async: true
  alias Todo.Task

  describe "to_json/1" do
    test "serialize to json map in happy path" do
      task = %Task{
        id: 1,
        title: "First Task",
        done: false
      }

      assert %{
               "id" => 1,
               "title" => "First Task",
               "done" => false
             } = Task.to_json(task)
    end
  end

  describe "from_json/1" do
    test "parse from json map in happy path" do
      json_map = %{
        "id" => 1,
        "title" => "First Task",
        "done" => false
      }

      assert %Task{
               id: 1,
               title: "First Task",
               done: false
             } = Task.from_json(json_map)
    end
  end
end
