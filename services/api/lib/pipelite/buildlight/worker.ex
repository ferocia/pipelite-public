# The purpose of this module is to perform the async update of a Lifx light.
# It accepts a new state to set for a particular light and will perform the
# necessary remote requests to attempt to put the light into that state.
defmodule Pipelite.Buildlight.Worker do
  use GenServer
  require Logger
  alias Pipelite.Buildlight.States

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call([project, build_state], _from, state) do
    ExSentry.capture_exceptions fn ->
      result = case update_light_state(project, build_state) do
        {:ok, _} ->
          Logger.info("[buildlight] updated #{project.name} state to #{build_state}")
          {:ok}
        {:error, reason} ->
          Logger.error("[buildlight] #{reason}")
          {:error, reason}
      end
      {:reply, [result], state}
    end
  end

  defp update_light_state(project, build_state) do
    case get_light(project.name) do
      {:ok, light} ->
        {:ok, _} = LifxAPI.breathe({:id, Dict.get(light, "id")}, States.get_state(build_state))
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_light(name) do
    {:ok, lights} = get_lights
    light = lights |> Enum.find(nil, fn(x) -> Map.get(x, "label") == name end)
    case light do
      nil -> {:error, "Lifx couldn't find a light named '#{name}'."}
      _   -> {:ok, light}
    end
  end

  defp get_lights do
    LifxAPI.lights({:group, lifx_group_selector})
  end

  defp lifx_group_selector do
    # TODO: move this out into an application level module with all other ENV vars?
    System.get_env("LIFX_BUILDKITE_GROUP")
  end
end
