class CreateAlertStates < ActiveRecord::Migration
  def change
    create_table :alert_states do |t|
      t.integer :alert_id
      t.integer :state_id
    end
  end
end
