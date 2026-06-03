defmodule Todo.Task do
  @enforce_keys [:id, :title]
  defstruct [:id, :title, done: false]
end
