defmodule Credo.Check.Readability.PreferUnquotedAtomsTest do
  use Credo.TestHelper

  @described_check Credo.Check.Readability.PreferUnquotedAtoms

  #
  # cases NOT raising issues
  #

  test "it should NOT report when using an unquoted atom" do
    """
    :unquoted_atom
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should NOT report when using an unquoted keyword identifier" do
    """
    [unquoted_atom: 1]
    %{unquoted_atom: 1}
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should NOT report when required to use a quoted atom" do
    """
    :"complex\#{atom}"
    :"complex atom"
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should NOT report when required to use a quoted keyword identifier" do
    """
    ["complex\#{atom}": 1, "complex atom": 2]
    %{"complex\#{atom}": 1, "complex atom": 2}
    """
    |> to_source_file
    |> refute_issues(@described_check)
  end

  #
  # cases raising issues
  #

  if Version.match?(System.version(), "< 1.7.0-dev") do
    #

    test "it should report cases where a quoted atom is used and could be unquoted" do
      """
      :"quoted_atom"
      """
      |> to_source_file
      |> assert_issue(@described_check)
    end

    test "it should report cases where a quoted keyword identifier is used and could be unquoted" do
      """
      ["quoted_atom": 1]
      %{"quoted_atom": 1}
      """
      |> to_source_file
      |> assert_issues(@described_check)
    end

    #
  end
end
