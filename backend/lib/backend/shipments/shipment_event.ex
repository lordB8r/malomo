defmodule Backend.Shipments.ShipmentEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shipment_events" do
    field(:description, :string)

    belongs_to(:shipment, Backend.Shipments.Shipment)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shipment_event, attrs) do
    shipment_event
    |> cast(attrs, [:shipment_id, :description])
    |> validate_required([:shipment_id, :description])
  end
end
