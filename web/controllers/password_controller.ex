defmodule PanelDemon.PasswordController do
  use PanelDemon.Web, :controller

  alias PanelDemon.User

  def forget_password(conn, _) do
    conn
    |> render(:forget_password)
  end

  def reset_password(conn, %{"user" => %{"email" => email}}) do
    conn
    |> put_flash(:info, "Password reset link has been sent to your email address.")
    |> redirect(to: session_path(conn, :new))
  end
end
