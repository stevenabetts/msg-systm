defmodule PanelDemon.ProcessTest do
  use PanelDemon.ModelCase

  alias PanelDemon.Process

  @valid_attrs %{i_queue: "some content", is_active: true, mps: 42, name: "some content", num_workers: 42, r_queue: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Process.changeset(%Process{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Process.changeset(%Process{}, @invalid_attrs)
    refute changeset.valid?
  end
end
