defmodule Backend.Tracking.Worker do
  use Oban.Worker, queue: :tracking

  @impl Oban.Worker
  def perform(%Job{args: %{"tracking_sim_id" => tracking_sim_id}}) do
    shipment = Backend.Repo.get_by!(Backend.Shipments.Shipment, tracking_sim_id: tracking_sim_id)

    case Backend.Tracking.Tracking.get_status(tracking_sim_id) do
      %{"state" => "unknown"} ->
        update_tracker_status(shipment, "unknown")
        {:snooze, 10}

      %{"state" => "pre_transit"} ->
        update_tracker_status(shipment, "pre_transit")
        {:snooze, 10}

      %{"state" => "in_transit"} ->
        update_tracker_status(shipment, "in_transit")
        {:snooze, 10}

      %{"state" => "out_for_delivery"} ->
        update_tracker_status(shipment, "out_for_delivery")
        {:snooze, 10}

      %{"state" => finale} ->
        update_tracker_status(shipment, finale)
        :ok
    end
  end

  defp update_tracker_status(shipment, stat) do
    Backend.Repo.transaction(fn ->
      shipment
      |> Ecto.Changeset.change(%{status: stat})
      |> Backend.Repo.update!()
    end)
  end
end
