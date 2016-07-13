defmodule PanelDemon.LogController do
  use PanelDemon.Web, :controller
  import Plug.Conn
  alias Passport.Plug
  alias Passport.Session

  plug :authenticate, usernames: []


  
  def log(conn, _params) do

      render conn, "log.html"
  end  


  defp authenticate(conn, options) do
    if get_session(conn, :user_id) do
      conn
    else
      conn |> redirect(to: session_path(conn, :new)) |> halt()
    end
  end


end
