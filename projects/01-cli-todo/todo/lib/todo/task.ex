defmodule Todo.Task do
  @moduledoc """
  A single task in a todo list.

  ## Fields

    * `id` — monotonic integer identifier
    * `title` — task description
    * `done` — completion status, defaults to `false`
  """
  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          done: boolean()
        }

  @enforce_keys [:id, :title]
  defstruct [:id, :title, done: false]

  @spec to_json(Todo.Task.t()) :: map()
  def to_json(%__MODULE__{id: id, title: title, done: done} = _task) do
    %{
      "id" => id,
      "title" => title,
      "done" => done
    }
  end

  @spec from_json(map()) :: t()
  def from_json(%{"id" => id, "title" => title, "done" => done} = _json_map) do
    %__MODULE__{
      id: id,
      title: title,
      done: done
    }
  end
end
