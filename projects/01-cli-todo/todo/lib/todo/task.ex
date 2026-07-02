defmodule Todo.Task do
  @moduledoc """
  A single task in a todo list.

  ## Fields

    * `id` — monotonic integer identifier
    * `title` — task description
    * `done` — completion status, defaults to `false`
  """
  @enforce_keys [:id, :title]
  defstruct [:id, :title, done: false]
end
