class AddAlertsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alert_id, :integer
  end
end
