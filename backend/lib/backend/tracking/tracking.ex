defmodule Backend.Tracking.Tracking do
  alias Backend.Shipments.Shipment
  alias Backend.Repo

  @doc """
  Used for creating a tracker for a shipment

  # Example

    iex> Backend.Tracking.TrackingSim.create_tracker("asd123", "JPAIR")
    {:ok, %Shipment{}}
    iex> Backend.Tracking.TrackingSim.create_tracker("asd123")
    {:error, "ERROR_STRING"}
  """
  @spec create_tracker(String.t(), String.t()) :: {:ok, Shipment.t()} | {:error, String.t()}
  def create_tracker(shipment_id, carrier_name, status \\ "unknown") do
    %{
      "id" => tracking_sim_id,
      "tracking_code" => tracking_code,
      "carrier" => carrier,
      "status" => status
    } = client_impl().create_tracker(shipment_id, carrier_name, status)

    with {:ok, %{shipment: shipment}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.insert(:shipment, %Shipment{
             tracking_code: tracking_code,
             carrier_name: carrier,
             status: String.to_existing_atom(status),
             tracking_sim_id: tracking_sim_id
           })
           |> Oban.insert(
             :worker,
             Backend.Tracking.Worker.new(%{tracking_sim_id: tracking_sim_id}, schedule_in: 1)
           )
           |> Repo.transaction(),
         do: shipment

    {:ok, tracking_code}
  end

  def get_status(tracker_id) do
    client_impl().get_status(tracker_id)
  end

  defp client_impl() do
    :backend
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:client)
  end
end
