defmodule Todo.Store do
  @moduledoc """
  JSON file persistence for the task list.

  Reads and writes a `Todo.TaskList` to disk so data survives between CLI runs.
  If no data file exists yet, `load!/1` returns an empty task list.
  """

  alias Todo.TaskList

  @type load_error :: File.posix() | Jason.DecodeError.t()

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

  @spec load(String.t()) :: {:ok, TaskList.t()} | {:error, load_error()}
  def load(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        parse_from_binary(content)

      {:error, :enoent} ->
        {:ok, TaskList.new()}

      {:error, error} ->
        {:error, error}
    end
  end

  defp parse_from_binary(content) when is_binary(content) do
    case Jason.decode(content) do
      {:ok, json_data} ->
        {:ok, TaskList.from_json(json_data)}

      {:error, error} ->
        {:error, error}
    end
  end
end
