defmodule Pipelite.JSON do
  @behaviour Ecto.Type

  def type, do: :json
  def cast(value), do: {:ok, value}
  def blank?(_), do: false

  def load(value) do
    {:ok, value}
  end

  def dump(value) do
    {:ok, value}
  end
end
