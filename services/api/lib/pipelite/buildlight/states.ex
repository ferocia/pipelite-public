defmodule Pipelite.Buildlight.States do
  defmodule Scheduled do
    defstruct power_on: true,
              color: "kelvin:4000 brightness:5%",
              from_color: "kelvin:4000 brightness:15%",
              period: 5,
              cycles: 9999,
              persist: true
  end

  defmodule Running do
    defstruct power_on: true,
              color: "#fff138 brightness:15%",
              from_color: "#fff138 brightness:35%",
              period: 5,
              cycles: 9999,
              persist: true
  end

  defmodule Passed do
    defstruct power_on: true,
              color: "#45e230 brightness:60%",
              from_color: "#45e230 brightness:10%",
              period: 0.45,
              cycles: 3,
              persist: true,
              peak: 0.2
  end

  defmodule Failed do
    defstruct power_on: true,
              color: "#f04d62 brightness:60%",
              from_color: "#f04d62 brightness:25%",
              period: 0.1,
              cycles: 20,
              persist: true,
              peak: 0.2
  end

  def get_state(state) do
    case String.to_atom(state) do
      :scheduled -> %__MODULE__.Scheduled{}
      :running   -> %__MODULE__.Running{}
      :passed    -> %__MODULE__.Passed{}
      :failed    -> %__MODULE__.Failed{}
      :canceled  -> %__MODULE__.Failed{}
    end |> Map.from_struct
  end
end
