class ChangeWaveHeightFromDecimalToFloatPrecisionNotNeeded < ActiveRecord::Migration
  def up
    change_column :forecasts, :min_height, :float
    change_column :forecasts, :max_height, :float
    change_column :surfhistories, :min_height, :float
    change_column :surfhistories, :max_height, :float
  end

  def down
    change_column :forecasts, :min_height, :decimal
    change_column :forecasts, :max_height, :decimal
    change_column :surfhistories, :min_height, :decimal
    change_column :surfhistories, :max_height, :decimal
  end
end
