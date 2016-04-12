class AddConstraintsForecasts < ActiveRecord::Migration

  def up

    add_index :forecasts, [:location_id, :day, :time], unique: true
    add_index :forecasts, :location_id

    change_column :forecasts, :solid_stars, :integer, default: 0, limit: 1
    change_column :forecasts, :faded_stars, :integer, default: 0, limit: 1
    change_column :forecasts, :min_height, :float, default: 0, precision: 3, scale: 1
    change_column :forecasts, :max_height, :float, default: 0, precision: 3, scale: 1
    change_column :forecasts, :period, :integer, default: 0

    change_column_null :forecasts, :time, :false
    change_column_null :forecasts, :day, :false
  end

  def down
    remove_index :forecasts, [:location_id, :day, :time]
    remove_index :forecasts, :location_id

    change_column :forecasts, :solid_stars, :integer
    change_column :forecasts, :faded_stars, :integer
    change_column :forecasts, :min_height, :float
    change_column :forecasts, :max_height, :float
    change_column :forecasts, :period, :integer

    change_column_null :forecasts, :time, :true
    change_column_null :forecasts, :day, :true
  end
end
