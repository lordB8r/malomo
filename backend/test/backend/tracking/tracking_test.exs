defmodule Backend.Tracking.TrackingTest do
  use Backend.DataCase, async: true

  import Mox

  alias Backend.Shipments.Shipment
  alias Backend.Repo

  setup :verify_on_exit!

  describe "create_tracker/3" do
    test "creates a shipment tracker" do
      expect(Backend.Tracking.TrackingSim.Mock, :create_tracker, fn _tracking_code,
                                                                    _carrier_name,
                                                                    _status ->
        %{
          "id" => "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56",
          "carrier" => "usps",
          "status" => "pre_transit",
          "tracking_code" => "asdf1234asdf",
          "inserted_at" => "2023-09-01T17:26:52",
          "updated_at" => "2023-09-01T17:27:32"
        }
      end)

      Backend.Tracking.Tracking.create_tracker(
        "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56",
        "usps",
        "asdf"
      )

      assert Repo.get_by!(Shipment, tracking_sim_id: "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56")
    end
  end
end
