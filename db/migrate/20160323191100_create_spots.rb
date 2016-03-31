class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :name
      t.string :state
      t.string :latitude
      t.string :longitude
      t.integer :msw_id

      t.timestamps null: false
    end
  end
end
