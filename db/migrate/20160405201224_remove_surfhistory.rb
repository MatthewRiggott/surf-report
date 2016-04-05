class RemoveSurfhistory < ActiveRecord::Migration
  def change
    drop_table :surfhistories
  end
end
