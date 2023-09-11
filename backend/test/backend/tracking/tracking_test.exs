defmodule Backend.Tracking.TrackingTest do
  use Backend.DataCase, async: true

  import Mox
  use Oban.Testing, repo: Backend.Repo

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
          "inserted_at" => "2023-09-01T17:26:52Z",
          "updated_at" => "2023-09-01T17:27:32Z"
        }
      end)

      Oban.Testing.with_testing_mode(:manual, fn ->
        Backend.Tracking.Tracking.create_tracker(
          "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56",
          "usps",
          "asdf"
        )

        assert_enqueued(
          worker: Backend.Tracking.Worker,
          args: %{tracking_sim_id: "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56"}
        )
      end)

      assert Repo.get_by!(Shipment, tracking_sim_id: "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56")
    end
  end

  describe "get_status/1" do
    test "returns current status of shipment" do
      expect(Backend.Tracking.TrackingSim.Mock, :get_status, fn _tracker_id ->
        %{
          "tracking_code" => "asdf1234asdf",
          "status" => "Delivered"
        }
      end)

      expect(Backend.Tracking.TrackingSim.Mock, :create_tracker, fn _tracking_code,
                                                                    _carrier_name,
                                                                    _status ->
        %{
          "id" => "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56",
          "carrier" => "usps",
          "status" => "pre_transit",
          "tracking_code" => "asdf1234asdf",
          "inserted_at" => "2023-09-01T17:26:52Z",
          "updated_at" => "2023-09-01T17:27:32Z"
        }
      end)

      Oban.Testing.with_testing_mode(:manual, fn ->
        Backend.Tracking.Tracking.create_tracker(
          "2ae4f4a9-d0c9-42d1-aed6-13891a1f2c56",
          "usps",
          "unknown"
        )
      end)

      %{"status" => status} = Backend.Tracking.Tracking.get_status("asdf1234asdf")

      assert status == "Delivered"
    end
  end
end
