class AddConstraintsLocations < ActiveRecord::Migration
  def change

    add_index :locations, [:name, :state], unique: true
    add_index :locations, :msw_id, unique: true
    add_index :locations, :url, unique: true

    change_column_null :locations, :name, :false
    change_column_null :locations, :msw_id, :false
    change_column_null :locations, :url, :false
    change_column_null :locations, :state, :false

  end

end
