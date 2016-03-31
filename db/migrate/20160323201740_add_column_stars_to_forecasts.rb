class AddColumnStarsToForecasts < ActiveRecord::Migration
  def change
    add_column :forecasts, :solid_stars, :integer
    add_column :forecasts, :faded_stars, :integer
  end
end
