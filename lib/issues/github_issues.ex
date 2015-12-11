defmodule Issues.GithubIssues do
  @user_agent  [ {"User-agent", "Elixir dave@pragprog.com"} ]

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
      |> convert_to_list_of_hashdicts
      |> sort_in_descending_order
  end

  @github_url Application.get_env(:issues, :github_url)
  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    { :ok, :jsx.decode(body) }
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: ___, body: body}}) do
    { :error, :jsx.decode(body) }
  end

  def handle_response({:error, _}) do
    { :error, IO.puts("Failed request") }
  end

  def convert_to_list_of_hashdicts({:ok, list}) do
    list |> Enum.map(&Enum.into(&1, HashDict.new))
  end

  def sort_in_descending_order(list) do
    Enum.sort list, fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end
end

