defmodule Backend.Repo.Migrations.UpdateShipmentsWithTrackingSimId do
  use Ecto.Migration

  def change do
    alter table(:shipments) do
      add(:tracking_sim_id, :string)
    end
  end
end
