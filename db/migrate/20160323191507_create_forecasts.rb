class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.integer :surfcast_id
      t.integer :time
      t.integer :day
      t.integer :period
      t.decimal :average_height

      t.timestamps null: false
    end
  end
end
