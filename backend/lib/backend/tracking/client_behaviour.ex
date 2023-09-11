defmodule Backend.Tracking.ClientBehaviour do
  @callback create_tracker(
              shipment_id :: String.t(),
              carrier_name :: String.t(),
              status :: String.t()
            ) ::
              {:ok, Backend.Shipment.t()} | {:error, String.t()}
  @callback get_status(tracker_id :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
end
