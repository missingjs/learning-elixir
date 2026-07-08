defmodule Todo.Store do
  @moduledoc """
  JSON file persistence for the task list.

  Reads and writes a `Todo.TaskList` to disk so data survives between CLI runs.
  If no data file exists yet, `load!/1` returns an empty task list.
  """

  alias Todo.TaskList

  @spec save!(
          String.t(),
          Todo.TaskList.t()
        ) :: :ok
  def save!(file_path, task_list) do
    serialized_data =
      task_list
      |> TaskList.to_json()
      |> Jason.encode!()

    File.write!(file_path, serialized_data)
  end

  @spec load!(String.t()) :: TaskList.t()
  def load!(file_path) do
    if File.exists?(file_path) do
      file_path
      |> File.read!()
      |> Jason.decode!()
      |> TaskList.from_json()
    else
      TaskList.new()
    end
  end
end
