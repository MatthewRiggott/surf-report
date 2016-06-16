class Alerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.boolean :sunday
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.integer :alert_states
    end
  end
end
