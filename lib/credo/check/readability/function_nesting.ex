defmodule RentPath.Credo.Check.FunctionNesting do
  @moduledoc """
  Use the pipe operator to chain functions together.

  # not preferred
  String.strip(String.downcase(some_string))

  # preferred
  some_string |> String.downcase() |> String.strip()

  # or
  some_string
  |> String.downcase()
  |> String.strip()
  """

  @explanation [check: @moduledoc]

  @message "Use the pipe operator to chain functions together"

  use Credo.Check, category: :refactor

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &find_nested_functions(&1, &2, issue_meta))
  end

  defp function?({nested_func, _, value}) when is_atom(nested_func) and not is_nil(value), do: true
  defp function?(_ast), do: false

  defp find_nested_functions({key, _, _} = ast, issues, _issue_meta) when key in [:defmoule, :do] do
    {ast, issues}
  end

  defp find_nested_functions({func, meta, inputs} = ast, issues, issue_meta) when is_atom(func) and is_list(inputs) do
    IO.inspect(inputs)
    if Enum.find(inputs, &function?/1) do
      {ast, [issue_for(issue_meta, meta[:line], func) | issues]}
    else
      {ast, issues}
    end
  end

  defp find_nested_functions({func, meta, input} = ast, issues, issue_meta) when is_atom(func) do
    if function?(input) do
      {ast, [issue_for(issue_meta, meta[:line], func) | issues]}
    else
      {ast, issues}
    end
  end

  defp find_nested_functions(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(issue_meta, message: @message, line_no: line_no, trigger: trigger)
  end
end
