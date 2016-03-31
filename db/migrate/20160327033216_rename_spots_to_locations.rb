class RenameSpotsToLocations < ActiveRecord::Migration
  def change
    rename_table('spots', 'locations')
  end
end
