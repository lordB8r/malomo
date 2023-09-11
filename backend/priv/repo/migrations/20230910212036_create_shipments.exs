defmodule Backend.Repo.Migrations.CreateShipments do
  use Ecto.Migration

  def up do
    create table(:shipments) do
      add(:tracking_code, :string)
      add(:carrier_name, :string)
      add(:status, :string)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:shipments, [:id, :carrier_name]))
  end

  def down do
    drop_if_exists(unique_index(:shipments, [:id, :carrier_name]))

    drop(table(:shipments))
  end
end
