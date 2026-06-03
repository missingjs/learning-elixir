defmodule Todo.TaskList do
  @moduledoc """
  Pure data structure: a collection of `Todo.Task` keyed by id, with monotonic id allocation.
  """

  alias Todo.Task

  defstruct tasks: %{}, next_id: 1

  @doc "Returns a new empty task list."
  def new(), do: %__MODULE__{}

  @doc "Adds a task with the given title. Returns `{updated_list, new_id}`."
  def add(%__MODULE__{tasks: tasks, next_id: id} = list, title) do
    task = %Task{id: id, title: title}
    {%{list | tasks: Map.put(tasks, id, task), next_id: id + 1}, id}
  end

  def fetch(%__MODULE__{tasks: tasks}, id) do
    case Map.fetch(tasks, id) do
      {:ok, task} -> {:ok, task}
      :error -> {:error, :not_found}
    end
  end

  def all(%__MODULE__{tasks: tasks}), do: tasks |> Map.values() |> Enum.sort_by(& &1.id)

  def mark_done(%__MODULE__{tasks: tasks} = list, id) do
    case Map.fetch(tasks, id) do
      {:ok, task} -> {:ok, %{list | tasks: Map.put(tasks, id, %{task | done: true})}}
      :error -> {:error, :not_found}
    end
  end

  def remove(%__MODULE__{tasks: tasks} = list, id) do
    case Map.fetch(tasks, id) do
      {:ok, _task} -> {:ok, %{list | tasks: Map.delete(tasks, id)}}
      :error -> {:error, :not_found}
    end
  end
end
