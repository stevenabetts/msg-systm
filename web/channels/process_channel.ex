defmodule PanelDemon.ProcessChannel do
  use PanelDemon.Web, :channel

  def join("processes:planner", payload, socket) do
    if authorized?(payload) do
    send self(), :after_join

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (processes:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
  
  def handle_info(:after_join, socket) do
    processes = (from p in PanelDemon.Process, order_by: [asc: p.id]) |> Repo.all
    push socket, "set_processes", %{processes: processes}
    {:noreply, socket}
end

def handle_in("request_activateprocess", payload, socket) do
  process = Repo.get!(PanelDemon.Process, payload["id"])
  process_params = %{is_active: !payload["isActive"]}
  changeset = PanelDemon.Process.changeset(process, process_params)

  case Repo.update(changeset) do
    {:ok, process} ->
      broadcast socket, "process_updated", process
      {:noreply, socket}
    {:error, _changeset} ->
      {:reply, {:error, %{message: "Something went wrong."}}, socket}
  end
end

def handle_in("request_changeworkers", payload, socket) do
  process = Repo.get!(PanelDemon.Process, payload["id"])
  process_params = %{num_workers: payload["value"]}
  changeset = PanelDemon.Process.changeset(process, process_params)

  case Repo.update(changeset) do
    {:ok, process} ->
      broadcast socket, "workers_updated", process
      {:noreply, socket}
    {:error, _changeset} ->
      {:reply, {:error, %{message: "Something went wrong."}}, socket}
  end
end

def handle_in("request_changemps", payload, socket) do
  process = Repo.get!(PanelDemon.Process, payload["id"])
  process_params = %{mps: payload["value"]}
  changeset = PanelDemon.Process.changeset(process, process_params)

  case Repo.update(changeset) do
    {:ok, process} ->
      broadcast socket, "mps_updated", process
      {:noreply, socket}
    {:error, _changeset} ->
      {:reply, {:error, %{message: "Something went wrong."}}, socket}
  end
end

def handle_in("request_updateinput", payload, socket) do
  process = Repo.get!(PanelDemon.Process, payload["id"])
  process_params = %{i_queue: payload["string"]}
  changeset = PanelDemon.Process.changeset(process, process_params)

  case Repo.update(changeset) do
    {:ok, process} ->
      broadcast socket, "input_updated", process
      {:noreply, socket}
    {:error, _changeset} ->
      {:reply, {:error, %{message: "Something went wrong."}}, socket}
  end
end

def handle_in("request_updateretry", payload, socket) do
  process = Repo.get!(PanelDemon.Process, payload["id"])
  process_params = %{r_queue: payload["string"]}
  changeset = PanelDemon.Process.changeset(process, process_params)

  case Repo.update(changeset) do
    {:ok, process} ->
      broadcast socket, "retry_updated", process
      {:noreply, socket}
    {:error, _changeset} ->
      {:reply, {:error, %{message: "Something went wrong."}}, socket}
  end
end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
