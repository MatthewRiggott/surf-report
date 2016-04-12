class AddLastCastTimeLocations < ActiveRecord::Migration
  def change
    add_column :locations, :forecast_updated_at, :timestamp
  end
end
