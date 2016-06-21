defmodule Pipelite.Buildlight do
  use Supervisor
  alias ExSentry

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Pipelite.Buildlight.Worker},
      {:size, 1},
      {:max_overflow, 2},
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def set!(light, state) do
    spawn fn -> transaction([light, state]) end
  end

  defp transaction(args) do
    :poolboy.transaction(pool_name(), fn(pid) ->
      GenServer.call(pid, args)
    end, :infinity)
  end

  defp pool_name() do
    :buildlight
  end
end
