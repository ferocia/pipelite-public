defmodule Pipelite.Activity.BuildActivitySelector do
  require Logger

  defmodule BuildStateChanged do
    def selector(changeset) do
      previous = Map.get(changeset.model, :state)
      next = Map.get(changeset.changes, :state)
      handle_state_change(previous, next)
    end

    defp handle_state_change(nil, _), do: nil
    defp handle_state_change(_, nil), do: nil
    defp handle_state_change(nil, nil), do: nil
    defp handle_state_change(previous, next) do
      if previous != next do
        %{
          selector: :build_state_changed,
          previous_state: previous,
          next_state: next
        }
      end
    end
  end

  def map(changeset) do
    [
      &BuildStateChanged.selector/1,
    ]
    |> Enum.map(fn(selector) -> selector.(changeset) end)
  end
end
