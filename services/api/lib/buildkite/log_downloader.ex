defmodule Buildkite.LogDownloader do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Buildkite.LogDownloader.Worker},
      {:size, 2},
      {:max_overflow, 10},
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def download!(job) do
    spawn fn -> transaction({:download!, job}) end
  end

  defp transaction(args) do
    :poolboy.transaction(pool_name(), fn(pid) ->
      GenServer.call(pid, args)
    end, :infinity)
  end

  defp pool_name() do
    :log_downloader
  end
end
