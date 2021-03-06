defmodule Credo.Check.Readability.ModuleNamesTest do
  use Credo.TestHelper

  @described_check Credo.Check.Readability.ModuleNames

  #
  # cases NOT raising issues
  #

  test "it should NOT report expected code" do
    """
    defmodule CredoSampleModule do
    end
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should NOT report if module name cannot be determinated" do
    """
    defmacro foo(quoted_module) do
      {module, []} = Code.eval_quoted(quoted_module)
      quote do
        defmodule unquote(module).Bar do
        end
      end
    end
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  #
  # cases raising issues
  #

  test "it should report a violation /2" do
    """
    defmodule Credo_SampleModule do
    end
    """
    |> to_source_file
    |> assert_issue(@described_check)
  end
end
