class AdjustForecastHistoryVariables < ActiveRecord::Migration
  def change
    remove_column :surfhistories, :average_height, :decimal
    add_column :surfhistories, :min_height, :decimal
    add_column :surfhistories, :max_height, :decimal
  end
end
