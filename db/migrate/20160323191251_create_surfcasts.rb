class CreateSurfcasts < ActiveRecord::Migration
  def change
    create_table :surfcasts do |t|
      t.integer :spot_id

      t.timestamps null: false
    end
  end
end
