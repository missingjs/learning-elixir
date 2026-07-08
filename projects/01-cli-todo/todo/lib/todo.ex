defmodule Todo do
  @moduledoc """
  A command-line TODO tool with JSON persistence.
  """

  alias Todo.{Store, Task, TaskList}

  @data_file "./.task_todo"

  def main(args) do
    {command, rest} = parse(args)
    task_list = Store.load!(@data_file)

    case dispatch(task_list, command, rest) do
      {:changed, task_list} -> Store.save!(@data_file, task_list)
      _ -> :ok
    end
  end

  defp parse([]) do
    print_usage()
    System.halt(0)
  end

  defp parse(args) do
    {_opts, [command | rest], _invalid} = OptionParser.parse(args, strict: [])
    {command, rest}
  end

  defp print_usage do
    IO.puts("""
    Usage:
      todo add <title>     Add a new task
      todo list            List all tasks
      todo get <id>        Show a task
      todo done <id>       Mark a task as done
      todo remove <id>     Remove a task
    """)
  end

  @spec dispatch(TaskList.t(), String.t(), [String.t()]) :: {:changed | :not_changed, TaskList.t()}
  def dispatch(task_list, "add", [title]) when is_binary(title) do
    {task_list, task_id} = TaskList.add(task_list, title)
    IO.puts("Task #{task_id} added")

    {:changed, task_list}
  end

  def dispatch(task_list, "list", []) do
    task_list
    |> TaskList.all()
    |> Enum.each(&display_task/1)

    {:not_changed, task_list}
  end

  def dispatch(task_list, "get", [task_id]) do
    case TaskList.fetch(task_list, String.to_integer(task_id)) do
      {:ok, task} -> display_task(task)
      {:error, :not_found} -> report_task_not_found(task_id)
    end

    {:not_changed, task_list}
  end

  def dispatch(task_list, "done", [task_id]) do
    case TaskList.mark_done(task_list, String.to_integer(task_id)) do
      {:ok, task_list} ->
        IO.puts("Mark task #{task_id} as DONE")
        {:changed, task_list}

      {:error, :not_found} ->
        report_task_not_found(task_id)
        {:not_changed, task_list}
    end
  end

  def dispatch(task_list, "remove", [task_id]) do
    case TaskList.remove(task_list, String.to_integer(task_id)) do
      {:ok, task_list} ->
        IO.puts("Task #{task_id} removed")
        {:changed, task_list}

      {:error, :not_found} ->
        report_task_not_found(task_id)
        {:not_changed, task_list}
    end
  end

  def dispatch(_task_list, command, _rest) do
    IO.puts("Unknown command #{command}")
    print_usage()
    System.halt(1)
  end

  defp display_task(%Task{id: id, title: title, done: done} = _task) do
    IO.puts("[#{id}] #{title} [#{task_status_string(done)}]")
  end

  defp report_task_not_found(task_id) do
    IO.puts("Task #{task_id} not found")
  end

  defp task_status_string(false), do: "TODO"
  defp task_status_string(true), do: "DONE"
end
