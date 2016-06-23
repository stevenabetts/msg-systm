defmodule PanelDemon.PageController do
  use PanelDemon.Web, :controller
  import Plug.Conn
  alias Passport.Plug
  alias Passport.Session

  plug :authenticate, usernames: []


  
  def index(conn, _params) do

      render conn, "index.html"
  end  


  defp authenticate(conn, options) do
    if get_session(conn, :user_id) do
      conn
    else
      conn |> redirect(to: session_path(conn, :new)) |> halt()
    end
  end


end

