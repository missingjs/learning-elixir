defmodule Todo.TaskList do
  @moduledoc """
  Pure data structure: a collection of `Todo.Task` keyed by id, with monotonic id allocation.
  """

  alias Todo.Task

  @type t :: %__MODULE__{
          tasks: %{integer() => Task.t()},
          next_id: integer()
        }

  defstruct tasks: %{}, next_id: 1

  @doc "Returns a new empty task list."
  @spec new() :: t()
  def new, do: %__MODULE__{}

  @doc "Adds a task with the given title."
  @spec add(t(), String.t()) :: {t(), integer()}
  def add(%__MODULE__{tasks: tasks, next_id: id} = list, title) do
    task = %Task{id: id, title: title}
    {%{list | tasks: Map.put(tasks, id, task), next_id: id + 1}, id}
  end

  @doc "Fetches a task by id."
  @spec fetch(t(), integer()) :: {:ok, Task.t()} | {:error, :not_found}
  def fetch(%__MODULE__{tasks: tasks}, id) do
    case Map.fetch(tasks, id) do
      {:ok, task} -> {:ok, task}
      :error -> {:error, :not_found}
    end
  end

  @doc "Returns all tasks sorted by id."
  @spec all(t()) :: [Task.t()]
  def all(%__MODULE__{tasks: tasks}), do: tasks |> Map.values() |> Enum.sort_by(& &1.id)

  @doc "Marks a task as done by id."
  @spec mark_done(t(), integer()) :: {:ok, t()} | {:error, :not_found}
  def mark_done(%__MODULE__{tasks: tasks} = list, id) do
    case fetch(list, id) do
      {:ok, task} -> {:ok, %{list | tasks: Map.put(tasks, id, %{task | done: true})}}
      {:error, _} = error -> error
    end
  end

  @doc "Removes a task by id."
  @spec remove(t(), integer()) :: {:ok, t()} | {:error, :not_found}
  def remove(%__MODULE__{tasks: tasks} = list, id) do
    case fetch(list, id) do
      {:ok, _task} -> {:ok, %{list | tasks: Map.delete(tasks, id)}}
      {:error, _} = error -> error
    end
  end

  @doc "Converts a task list into a JSON-compatible map."
  @spec to_json(t()) :: map()
  def to_json(%__MODULE__{tasks: tasks, next_id: next_id} = _list) do
    %{
      "tasks" => Map.new(tasks, fn {id, task} -> {Integer.to_string(id), Task.to_json(task)} end),
      "next_id" => next_id
    }
  end

  @doc "Builds a task list from a parsed JSON map."
  @spec from_json(map()) :: t()
  def from_json(%{"tasks" => tasks, "next_id" => next_id} = _json_data) do
    %__MODULE__{
      tasks: Map.new(tasks, fn {id, task} -> {String.to_integer(id), Task.from_json(task)} end),
      next_id: next_id
    }
  end
end
