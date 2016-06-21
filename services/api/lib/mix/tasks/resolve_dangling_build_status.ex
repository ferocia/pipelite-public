defmodule Mix.Tasks.Pipelite.ResolveDanglingBuildStatus do
  use Mix.Task
  use Timex
  alias Pipelite.Repo
  import Ecto.Query, only: [from: 2]

  @shortdoc "Finds and resolve Build statuses that never properly synced."

  def run(_) do
    Repo.start_link
    # query = from build in Pipelite.Build,
      # where: build.state == ~s(running) and build.updated_at < Timex.shift(DateTime.now, days: 1)
    # Repo.all(query) |> IO.inspect

    IO.inspect(DateTime.now)
    IO.inspect(Timex.shift(DateTime.now, days: 1))
  end
end
