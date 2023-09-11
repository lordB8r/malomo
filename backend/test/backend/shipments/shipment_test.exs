defmodule Backend.Shipments.ShipmentTest do
  use Backend.DataCase

  alias Backend.Shipments.Shipment

  describe "shipments" do
    @valid_attrs %{carrier_name: "UPS", tracking_code: "234xc234asdxcv234", status: "unknown"}
    @missing_carrier_attrs %{tracking_code: "234xc234asdxcv234"}
    @missing_status_attrs %{
      carrier_name: "UPS",
      tracking_code: "234xc234asdxcv234"
    }

    test "creating with valid attributes" do
      assert {:ok, %Shipment{} = _shipment} =
               %Shipment{}
               |> Shipment.changeset(@valid_attrs)
               |> Repo.insert()
    end

    test "carrier_name is required" do
      assert {:error, _response} =
               %Shipment{}
               |> Shipment.changeset(@missing_carrier_attrs)
               |> Repo.insert()
    end

    test "status is required" do
      assert {:error, _response} =
               %Shipment{}
               |> Shipment.changeset(@missing_status_attrs)
               |> Repo.insert()
    end
  end
end
