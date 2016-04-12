# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160412170608) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forecasts", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "time"
    t.integer  "day"
    t.integer  "period",                default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "solid_stars", limit: 2, default: 0
    t.integer  "faded_stars", limit: 2, default: 0
    t.float    "min_height",            default: 0.0
    t.float    "max_height",            default: 0.0
  end

  add_index "forecasts", ["location_id", "day", "time"], name: "index_forecasts_on_location_id_and_day_and_time", unique: true, using: :btree
  add_index "forecasts", ["location_id"], name: "index_forecasts_on_location_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "msw_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "url"
    t.datetime "forecast_updated_at"
  end

  add_index "locations", ["msw_id"], name: "index_locations_on_msw_id", unique: true, using: :btree
  add_index "locations", ["name", "state"], name: "index_locations_on_name_and_state", unique: true, using: :btree
  add_index "locations", ["url"], name: "index_locations_on_url", unique: true, using: :btree

end
