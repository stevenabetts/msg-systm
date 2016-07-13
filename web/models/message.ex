defmodule PanelDemon.Message do
  use PanelDemon.Web, :model

  schema "messages" do
    field :status, :boolean, default: false
    field :delivered_at, Ecto.DateTime, default: Ecto.DateTime.utc
    field :tags, {:array, :string}

    timestamps
  end

  @required_fields ~w(status delivered_at tags)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

defimpl Poison.Encoder, for: PanelDemon.Message do
  def encode(model, opts) do
    %{id: model.id,
      status: model.status,
      deliveredAt: model.delivered_at,
      tags: model.tags} |> Poison.Encoder.encode(opts)
  end
end
