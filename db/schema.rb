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

ActiveRecord::Schema.define(version: 20140531040853) do

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_type_id"
    t.integer  "measurement_type_id"
    t.datetime "last_accessed"
    t.integer  "num_measured"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["activity_type_id"], name: "index_activities_on_activity_type_id"
  add_index "activities", ["measurement_type_id"], name: "index_activities_on_measurement_type_id"
  add_index "activities", ["user_id", "activity_type_id"], name: "index_activities_on_user_id_and_activity_type_id", unique: true
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

  create_table "activity_words", force: true do |t|
    t.integer  "activity_type_id"
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_words", ["activity_type_id"], name: "index_activity_words_on_activity_type_id"

  create_table "challenges", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "content"
    t.integer  "status",      default: 1
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
  end

  add_index "challenges", ["receiver_id"], name: "index_challenges_on_receiver_id"
  add_index "challenges", ["sender_id"], name: "index_challenges_on_sender_id"

  create_table "comment_down_voters", force: true do |t|
    t.integer "user_id"
    t.integer "comment_id"
  end

  create_table "comment_readers", force: true do |t|
    t.integer "user_id"
    t.integer "comment_id"
  end

  create_table "comment_up_voters", force: true do |t|
    t.integer "user_id"
    t.integer "comment_id"
  end

  create_table "comments", force: true do |t|
    t.integer  "activity_type_id"
    t.integer  "author_id"
    t.integer  "votes"
    t.text     "content"
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["activity_type_id"], name: "index_comments_on_activity_type_id"

  create_table "friends", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "accepted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["friend_id"], name: "index_friends_on_friend_id"
  add_index "friends", ["user_id"], name: "index_friends_on_user_id"

  create_table "goal_types", force: true do |t|
    t.integer  "guide_id"
    t.integer  "activity_type_id"
    t.integer  "measurement_type_id"
    t.boolean  "is_repeated"
    t.boolean  "requires_greater"
    t.float    "measurement_value"
    t.integer  "days_to_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goal_types", ["activity_type_id"], name: "index_goal_types_on_activity_type_id"
  add_index "goal_types", ["guide_id"], name: "index_goal_types_on_guide_id"
  add_index "goal_types", ["measurement_type_id"], name: "index_goal_types_on_measurement_type_id"

  create_table "goals", force: true do |t|
    t.integer  "goal_type_id"
    t.integer  "activity_id"
    t.integer  "completing_measurement_id"
    t.datetime "start_time"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["activity_id"], name: "index_goals_on_activity_id"
  add_index "goals", ["goal_type_id"], name: "index_goals_on_goal_type_id"

  create_table "guides", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "happiness_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "happiness_categories_questions", force: true do |t|
    t.integer "happiness_category_id"
    t.integer "happiness_question_id"
  end

  create_table "happiness_questions", force: true do |t|
    t.text     "content"
    t.integer  "max_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "happiness_responses", force: true do |t|
    t.integer  "happiness_question_id"
    t.integer  "value"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "happiness_responses", ["happiness_question_id"], name: "index_happiness_responses_on_happiness_question_id"
  add_index "happiness_responses", ["user_id"], name: "index_happiness_responses_on_user_id"

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

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "content"
    t.text     "quote"
    t.text     "sender_sig"
    t.text     "receiver_sig"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "response_down_voters", force: true do |t|
    t.integer "user_id"
    t.integer "response_id"
  end

  create_table "response_readers", force: true do |t|
    t.integer "user_id"
    t.integer "response_id"
  end

  create_table "response_up_voters", force: true do |t|
    t.integer "user_id"
    t.integer "response_id"
  end

  create_table "responses", force: true do |t|
    t.integer  "comment_id"
    t.integer  "author_id"
    t.integer  "votes"
    t.text     "content"
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["comment_id"], name: "index_responses_on_comment_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.integer  "phone"
    t.string   "username"
    t.string   "remember_token"
    t.string   "country"
    t.string   "city"
    t.integer  "readable_comments_count"
    t.integer  "readable_responses_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "is_happy",                 default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
