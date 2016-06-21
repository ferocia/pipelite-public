defmodule Pipelite.Api.BuildFilters do
  alias Pipelite.Build
  alias Pipelite.Api

  def filter_all(query, params) do
    query
    |> project(params)
    |> branch(params)
    |> state(params)
    |> limit(params)
    |> sort(params)
    |> date(params)
    |> period(params)
  end

  # TODO: needs pagination...
  def limit(q, %{"limit" => limit}) when is_integer(limit), do: Build.with_limit(q, limit)
  def limit(q, _), do: Build.with_limit(q, Api.default_limit)

  def project(q, %{"project" => id}) when is_integer(id), do: Build.find_by_project_id(q, id)
  def project(q, _), do: q

  def branch(q, %{"branch" => branch}), do: Build.find_by_branch(q, branch)
  def branch(q, _), do: q

  def state(q, %{"state" => state}), do: Build.find_by_state(q, state)
  def state(q, _), do: q

  # TODO Support GitHub style sort filtering (https://developer.github.com/v3/pulls/#parameters)
  def sort(q, %{"sort" => "asc"}), do: Build.with_ordered_asc(q)
  def sort(q, %{"sort" => "desc"}), do: Build.with_ordered_desc(q)
  def sort(q, _), do: q

  def date(q, %{"start_date" => start_date}), do: Build.find_by_created_after_date(q, start_date)
  def date(q, %{"end_date" => end_date}), do: Build.find_by_updated_before_date(q, end_date)
  def date(q, _), do: q

  def period(q, %{"period" => "7days"}), do: Build.find_by_created_in_n_days(q, 7)
  def period(q, %{"period" => "30days"}), do: Build.find_by_created_in_n_days(q, 30)
  def period(q, %{"period" => "60days"}), do: Build.find_by_created_in_n_days(q, 60)
  def period(q, _), do: q
end
