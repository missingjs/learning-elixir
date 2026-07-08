defmodule Todo do
  @moduledoc """
  A command-line TODO tool with JSON persistence.
  """

  alias Todo.{Store, Task, TaskList}

  @data_file "./.task_todo"

  @type change_status :: :changed | :not_changed
  @type dispatch_error ::
          :invalid_task_id
          | :task_not_found
          | :unknown_command
          | :missing_argument
          | :unknown_argument
          | :empty_title

  def main(args) do
    {command, rest} = parse(args)
    task_list = Store.load!(@data_file)

    case dispatch(task_list, command, rest) do
      {:changed, task_list} -> Store.save!(@data_file, task_list)
      {:not_changed, _task_list} -> :ok
      {:error, _reason} -> System.halt(1)
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

  @spec dispatch(TaskList.t(), String.t(), [String.t()]) ::
          {change_status(), TaskList.t()} | {:error, dispatch_error()}
  def dispatch(task_list, "add", [title]) when is_binary(title) and title != "" do
    {task_list, task_id} = TaskList.add(task_list, title)
    IO.puts("Task #{task_id} added")

    {:changed, task_list}
  end

  def dispatch(_task_list, "add", [""]) do
    IO.puts("Task title can not be empty")
    {:error, :empty_title}
  end

  def dispatch(_task_list, "add", []) do
    print_usage()
    {:error, :missing_argument}
  end

  def dispatch(_task_list, "add", [_first | _rest]) do
    print_usage()
    {:error, :unknown_argument}
  end

  def dispatch(task_list, "list", []) do
    task_list
    |> TaskList.all()
    |> Enum.each(&display_task/1)

    {:not_changed, task_list}
  end

  def dispatch(_task_list, "list", _args) do
    print_usage()
    {:error, :unknown_argument}
  end

  def dispatch(task_list, "get", [task_id]) do
    case Integer.parse(task_id) do
      {id, ""} ->
        do_get(task_list, id)

      _ ->
        IO.puts("Task id '#{task_id}' should be an integer.")
        {:error, :invalid_task_id}
    end
  end

  def dispatch(task_list, "done", [task_id]) do
    case Integer.parse(task_id) do
      {id, ""} ->
        do_mark_done(task_list, id)

      _ ->
        IO.puts("Task id '#{task_id}' should be an integer.")
        {:error, :invalid_task_id}
    end
  end

  def dispatch(task_list, "remove", [task_id]) do
    case Integer.parse(task_id) do
      {id, ""} ->
        do_remove(task_list, id)

      _ ->
        IO.puts("Task id '#{task_id}' should be an integer.")
        {:error, :invalid_task_id}
    end
  end

  def dispatch(_task_list, command, []) when command in ~w(done remove get) do
    print_usage()
    {:error, :missing_argument}
  end

  def dispatch(_task_list, command, [_first | _rest]) when command in ~w(done remove get) do
    print_usage()
    {:error, :unknown_argument}
  end

  def dispatch(_task_list, command, _rest) do
    IO.puts("Unknown command #{command}")
    print_usage()
    {:error, :unknown_command}
  end

  defp display_task(%Task{id: id, title: title, done: done} = _task) do
    IO.puts("[#{id}] #{title} [#{task_status_string(done)}]")
  end

  defp do_remove(task_list, task_id) do
    case TaskList.remove(task_list, task_id) do
      {:ok, task_list} ->
        IO.puts("Task #{task_id} removed")
        {:changed, task_list}

      {:error, :not_found} ->
        report_task_not_found(task_id)
        {:error, :task_not_found}
    end
  end

  defp do_mark_done(task_list, task_id) do
    case TaskList.mark_done(task_list, task_id) do
      {:ok, task_list} ->
        IO.puts("Mark task #{task_id} as DONE")
        {:changed, task_list}

      {:error, :not_found} ->
        report_task_not_found(task_id)
        {:error, :task_not_found}
    end
  end

  defp do_get(task_list, task_id) do
    case TaskList.fetch(task_list, task_id) do
      {:ok, task} ->
        display_task(task)
        {:not_changed, task_list}

      {:error, :not_found} ->
        report_task_not_found(task_id)
        {:error, :task_not_found}
    end
  end

  defp report_task_not_found(task_id) do
    IO.puts("Task #{task_id} not found")
  end

  defp task_status_string(false), do: "TODO"
  defp task_status_string(true), do: "DONE"
end
