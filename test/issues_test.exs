defmodule IssuesTest do
  use ExUnit.Case

  import Issues.GithubIssues, only: [ sort_into_ascending_order: 1,
                                      convert_to_list_of_hashdicts: 1 ]

  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    data = for value <- values,
           do: [{"created_at", value}, {"other_data", "xxx"} ]
    convert_to_list_of_hashdicts data
  end
end
