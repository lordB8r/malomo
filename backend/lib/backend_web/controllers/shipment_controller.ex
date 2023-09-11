defmodule BackendWeb.ShipmentController do
  use BackendWeb, :controller

  alias Backend.Repo

  def shipments(%Plug.Conn{} = conn, _params) do
    shipments = Repo.all(Backend.Shipments.Shipment)

    json(conn, shipments)
  end

  def create_shipment(conn, params) do
    with {:ok, shipment} <-
           Backend.Tracking.Tracking.create_tracker(params["tracking_code"], params["carrier"]) do
      json(conn, Jason.encode!(shipment))
    else
      {:error, message} ->
        conn
        |> put_status(429)
        |> json(%{error: message})
    end
  end
end
