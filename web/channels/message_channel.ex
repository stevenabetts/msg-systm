defmodule PanelDemon.MessageChannel do
  use PanelDemon.Web, :channel

  def join("messages:lobby", payload, socket) do
    if authorized?(payload) do
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
  # broadcast to everyone in the current topic (messages:lobby).
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

def handle_in("request_searchmessage", payload, socket) do
    #fetchlist = list of msg ID's that contain payload tags
    #query = from m in PanelDemon.Message, where: ^payload in m.tags
    #results = Repo.all(finalquery)
    listoflists = Enum.map(payload, fn(x) -> Repo.all(from m in PanelDemon.Message, where: ^x in m.tags, select: m.id) end)
    fetchlist = Enum.uniq(Enum.concat(listoflists))
    finalquery = from m in PanelDemon.Message, where: m.id in ^fetchlist, select: struct(m, [:id, :status, :delivered_at, :tags])
    #finalquery = PanelDemon.Message |> where([m], m.id in fetchlist) |> select([:id, :status, :delivered_at, :tags])
    results = Repo.all(finalquery)
    broadcast socket, "results_obtained", %{content: results}
    {:noreply, socket}
end
  
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
