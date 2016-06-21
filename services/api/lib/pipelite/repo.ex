defmodule Pipelite.Repo do
  use Ecto.Repo, otp_app: :pipelite
  use Scrivener, page_size: 10

  def upsert!(nil, changeset), do: insert!(changeset)
  def upsert!(_model, changeset), do: update!(changeset)
end
