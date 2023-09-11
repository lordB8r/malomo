defmodule Backend.Repo.Migrations.AddChangedAtToShipmentEvents do
  use Ecto.Migration

  def change do
    alter table(:shipment_events) do
      add(:changed_at, :utc_datetime)
    end

    rename(table("shipment_events"), :description, to: :status)
  end
end
