defmodule PanelDemon.Message do
  use PanelDemon.Web, :model

  schema "messages" do
    field :status, :boolean, default: false
    field :date, Ecto.DateTime, default: Ecto.DateTime.utc #delievered at

    #have column for tags???? As json or csv??
    has_many :tags, PanelDemon.Tags
    timestamps
  end

  @required_fields ~w(status date)
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

