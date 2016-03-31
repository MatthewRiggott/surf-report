class AdjustForecastVariables < ActiveRecord::Migration
  def change
    remove_column :forecasts, :average_height, :decimal
    add_column :forecasts, :min_height, :decimal
    add_column :forecasts, :max_height, :decimal
  end
end
