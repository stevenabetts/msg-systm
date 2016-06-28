defmodule PanelDemon.MessageTest do
  use PanelDemon.ModelCase

  alias PanelDemon.Message

  @valid_attrs %{delivered_at: "2010-04-17 14:00:00", status: true, tags: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
