class CreateSurfhistories < ActiveRecord::Migration
  def change
    create_table :surfhistories do |t|
      t.integer :surfcast_id
      t.integer :day
      t.integer :period
      t.decimal :average_height

      t.timestamps null: false
    end
  end
end
