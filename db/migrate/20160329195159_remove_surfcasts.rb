class RemoveSurfcasts < ActiveRecord::Migration
  def change
    drop_table :surfcasts
    rename_column :forecasts, :surfcast_id, :location_id
    rename_column :surfhistories, :surfcast_id, :location_id
  end
end
