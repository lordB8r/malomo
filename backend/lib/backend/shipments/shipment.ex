defmodule Backend.Shipments.Shipment do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder, only: [:tracking_code, :carrier_name, :status]}

  schema "shipments" do
    field(:carrier_name, :string)
    field(:tracking_code, :string)
    field(:tracking_sim_id, :string)

    field(:status, Ecto.Enum,
      values: [
        :unknown,
        :pre_transit,
        :in_transit,
        :out_for_delivery,
        :delivered,
        :available_for_pickup,
        :return_to_sender,
        :failure,
        :cancelled,
        :error
      ]
    )

    has_many(:shipment_events, Backend.Shipments.ShipmentEvent)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shipments, attrs) do
    shipments
    |> cast(attrs, [:tracking_code, :carrier_name, :status, :tracking_sim_id])
    |> validate_required([:tracking_code, :carrier_name, :status, :tracking_sim_id])
  end
end
