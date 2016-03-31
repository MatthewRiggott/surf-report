class RenameSpotIdToLocationId < ActiveRecord::Migration
  def change
    rename_column :surfcasts, :spot_id, :location_id
  end
end
