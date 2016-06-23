defmodule PanelDemon.Process do
  use PanelDemon.Web, :model

  schema "processes" do
    field :name, :string
    field :is_active, :boolean, default: false
    field :mps, :integer
    field :num_workers, :integer
    field :i_queue, :string
    field :r_queue, :string

    timestamps
  end

  @required_fields ~w(name is_active mps num_workers i_queue r_queue)
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

defimpl Poison.Encoder, for: PanelDemon.Process do
  def encode(model, opts) do
    %{id: model.id,
      name: model.name,
      isActive: model.is_active,
      mps: model.mps,
      numWorkers: model.num_workers,
      iQueue: model.i_queue,
      rQueue: model.r_queue} |> Poison.Encoder.encode(opts)
  end
end
