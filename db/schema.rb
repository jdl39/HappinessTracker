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

ActiveRecord::Schema.define(version: 20140418203721) do

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_type_id"
    t.datetime "last_accessed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["activity_type_id"], name: "index_activities_on_activity_type_id"
  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "activities_measurement_types", id: false, force: true do |t|
    t.integer "activity_id"
    t.integer "measurement_type_id"
  end

  create_table "activity_types", force: true do |t|
    t.string   "name"
    t.integer  "num_users"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_types", ["name"], name: "index_activity_types_on_name", unique: true

  create_table "goal_types", force: true do |t|
    t.integer  "guide_id"
    t.integer  "activity_type_id"
    t.integer  "measurement_type_id"
    t.boolean  "is_repeated"
    t.boolean  "requires_greater"
    t.float    "measure_value"
    t.integer  "seconds_to_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goal_types", ["activity_type_id"], name: "index_goal_types_on_activity_type_id"
  add_index "goal_types", ["guide_id"], name: "index_goal_types_on_guide_id"
  add_index "goal_types", ["measurement_type_id"], name: "index_goal_types_on_measurement_type_id"

  create_table "goals", force: true do |t|
    t.integer  "goal_type_id"
    t.integer  "activity_id"
    t.integer  "num_times_completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["activity_id"], name: "index_goals_on_activity_id"
  add_index "goals", ["goal_type_id"], name: "index_goals_on_goal_type_id"

  create_table "guides", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_notes", force: true do |t|
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_types", force: true do |t|
    t.boolean  "is_quantifiable"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", force: true do |t|
    t.integer  "measurement_type_id"
    t.integer  "measurement_note_id"
    t.integer  "activity_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurements", ["activity_id"], name: "index_measurements_on_activity_id"
  add_index "measurements", ["measurement_note_id"], name: "index_measurements_on_measurement_note_id"
  add_index "measurements", ["measurement_type_id"], name: "index_measurements_on_measurement_type_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.integer  "phone"
    t.string   "username"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
