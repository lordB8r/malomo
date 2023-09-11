defmodule Backend.Tracking.Worker do
  use Oban.Worker, queue: :tracking

  @impl Oban.Worker
  def perform(%Job{args: %{"tracking_sim_id" => tracking_sim_id}}) do
    shipment = Backend.Repo.get_by!(Backend.Shipments.Shipment, tracking_sim_id: tracking_sim_id)

    case Backend.Tracking.Tracking.get_status(tracking_sim_id) do
      %{"status" => "unknown", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "unknown", updated_at)
        {:snooze, 10}

      %{"status" => "pre_transit", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "pre_transit", updated_at)
        {:snooze, 10}

      %{"status" => "in_transit", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "in_transit", updated_at)
        {:snooze, 10}

      %{"status" => "out_for_delivery", "updated_at" => updated_at} ->
        update_tracker_status(shipment, "out_for_delivery", updated_at)
        {:snooze, 10}

      %{"status" => finale, "updated_at" => updated_at} ->
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

    {_, upd_at, _} = DateTime.from_iso8601(updated_at <> "Z")

    %Backend.Shipments.ShipmentEvent{
      shipment: shipment,
      status: status,
      changed_at: upd_at
    }
    |> Backend.Repo.insert!()
  end
end
