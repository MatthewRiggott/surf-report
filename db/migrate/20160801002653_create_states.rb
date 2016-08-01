class CreateStates < ActiveRecord::Migration
  def up
    create_table :states do |t|
      t.string :name
    end

    add_index :states, :name, unique: true
    add_column :locations, :state_id, :integer

    Location.all.each do |l|
      state = l.state
      if !State.find_by(name: state)
        State.create(name: l.state)
      end

      l.update(state_id: State.find_by(name: state).id)
    end

    remove_column :locations, :state
  end

  def down
    add_column :locations, :state, :string

    Location.all.each do |l|
      l.update(state: State.find(l.state_id).name)
    end

    remove_column :locations, :state_id
    drop_table :states
  end
end
