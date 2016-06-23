defmodule PanelDemon.SeatTest do
  use PanelDemon.ModelCase

  alias PanelDemon.Seat

  @valid_attrs %{occupied: true, seat_no: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Seat.changeset(%Seat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Seat.changeset(%Seat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
