defmodule Backend.Repo.Migrations.CreateShipmentEvents do
  use Ecto.Migration

  def change do
    create table(:shipment_events) do
      add(:shipment_id, references(:shipments))
      add(:description, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:shipment_events, :shipment_id))
  end
end
