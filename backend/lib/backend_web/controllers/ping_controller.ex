defmodule BackendWeb.PingController do
  use BackendWeb, :controller

  def ping(%Plug.Conn{} = conn, _params) do
    text(conn, "PONG")
  end
end
