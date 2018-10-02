defmodule Rentpath.Credo.Check.FunctionNestingTest do
  use Credo.TestHelper

  @described_check RentPath.Credo.Check.FunctionNesting

  test "it should NOT report single line pipechains" do
    """
    defmodule FunctionNesting do
      def some_function do
        100 |> some_special_fun() |> another_fun()
      and
    end
    """
    |> to_source_file()
    |> refute_issues(@described_check)
  end

  test "it should NOT report pipechains" do
    """
    defmodule FunctionNesting do
      def some_function do
        100
        |> some_special_fun()
        |> another_fun()
      and
    end
    """
    |> to_source_file()
    |> refute_issues(@described_check)
  end

  test "it should NOT report single function with args" do
    """
    defmodule FunctionNesting do
      def some_function do
        value = 10
        another_fun(value)
      end
    end
    """
    |> to_source_file()
    |> refute_issues(@described_check)
  end

  test "it should report nested functions" do
    """
    defmodule FunctionNesting do
      def some_function do
        another_fun(some_special_fun(100))
      end
    end
    """
    |> to_source_file()
    |> assert_issue(@described_check)
  end

  test "it should report nested functions without args" do
    """
    defmodule FunctionNesting do
      def some_function do
        another_fun(some_special_fun())
      end
    end
    """
    |> to_source_file()
    |> assert_issue(@described_check)
  end
end
