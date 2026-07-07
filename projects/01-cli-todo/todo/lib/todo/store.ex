defmodule Todo.Store do
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
    file_path
    |> File.read!()
    |> Jason.decode!()
    |> TaskList.from_json()
  end
end
