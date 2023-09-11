defmodule Backend.Tracking.Worker do
  use Oban.Worker, queue: :tracking

  @impl Oban.Worker
  def perform(%Job{args: %{"tracking_sim_id" => tracking_sim_id}}) do
    shipment = Backend.Repo.get_by!(Backend.Shipments.Shipment, tracking_sim_id: tracking_sim_id)

    case Backend.Tracking.Tracking.get_status(tracking_sim_id) do
      %{"state" => "unknown", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "unknown", updated_at)
        {:snooze, 10}

      %{"state" => "pre_transit", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "pre_transit", updated_at)
        {:snooze, 10}

      %{"state" => "in_transit", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "in_transit", updated_at)
        {:snooze, 10}

      %{"state" => "out_for_delivery", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "out_for_delivery", updated_at)
        {:snooze, 10}

      %{"state" => finale, "updated_at" => updated_at} ->
        update_tracker_status(shipment, finale, updated_at)
        :ok
    end
  end

  defp update_tracker_status(shipment, status, updated_at) do
    Backend.Repo.transaction(fn ->
      shipment
      |> Ecto.Changeset.change(%{status: String.to_existing_atom(status)})
      |> Backend.Repo.update!()
    end)

    ship_event = Backend.Repo.get_by(Backend.Shipments.ShipmentEvent, shipment_id: shipment.id)
    upd_at = DateTime.from_iso8601(updated_at <> "Z")

    Backend.Repo.transaction(fn ->
      ship_event
      |> Ecto.Changeset.change(%{changed_at: upd_at, status: String.to_existing_atom(status)})
      |> Backend.Repo.insert!()
    end)
  end
end
