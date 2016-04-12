class NullMigration < ActiveRecord::Migration
  def up
    create_table "forecasts", force: :cascade do |t|
      t.integer  "location_id"
      t.integer  "time"
      t.integer  "day"
      t.integer  "period"
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
      t.integer  "solid_stars"
      t.integer  "faded_stars"
      t.float    "min_height"
      t.float    "max_height"
    end

    create_table "locations", force: :cascade do |t|
      t.string   "name"
      t.string   "state"
      t.string   "latitude"
      t.string   "longitude"
      t.integer  "msw_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string   "url"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
