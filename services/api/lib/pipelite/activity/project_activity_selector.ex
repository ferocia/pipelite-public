defmodule Pipelite.Activity.ProjectActivitySelector do
  require Logger

  defmodule Selectors do
    def project_created(changeset) do
      if changeset.action == :insert do
        %{
          selector: :project_created
        }
      end
    end
  end

  def map(changeset) do
    [
      &Selectors.project_created/1,
    ]
    |> Enum.map(fn(selector) -> selector.(changeset) end)
  end
end
