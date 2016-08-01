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

ActiveRecord::Schema.define(version: 20160801002653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alert_states", force: :cascade do |t|
    t.integer "alert_id"
    t.integer "state_id"
  end

  create_table "alerts", force: :cascade do |t|
    t.boolean "sunday"
    t.boolean "monday"
    t.boolean "tuesday"
    t.boolean "wednesday"
    t.boolean "thursday"
    t.boolean "friday"
    t.boolean "saturday"
    t.integer "alert_states"
  end

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
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "msw_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "url"
    t.datetime "forecast_updated_at"
    t.integer  "state_id"
  end

  add_index "locations", ["msw_id"], name: "index_locations_on_msw_id", unique: true, using: :btree
  add_index "locations", ["url"], name: "index_locations_on_url", unique: true, using: :btree

  create_table "states", force: :cascade do |t|
    t.string "name"
  end

  add_index "states", ["name"], name: "index_states_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "",    null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "zipcode",                                null: false
    t.string   "latitude"
    t.string   "longitude"
    t.boolean  "is_active",              default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "alert_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
