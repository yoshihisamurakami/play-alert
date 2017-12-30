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

ActiveRecord::Schema.define(version: 20171230111910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.bigint "stage_id"
    t.bigint "user_id"
    t.boolean "seven_days", default: false, null: false
    t.boolean "three_days", default: false, null: false
    t.boolean "one_day", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_alerts_on_stage_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "stage_details", force: :cascade do |t|
    t.bigint "stage_id"
    t.text "cast"
    t.text "playwright"
    t.text "director"
    t.text "price"
    t.text "site"
    t.text "timetable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_stage_details_on_stage_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "url"
    t.string "title"
    t.string "group"
    t.string "theater"
    t.date "startdate"
    t.date "enddate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_stars", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_user_stars_on_stage_id"
    t.index ["user_id", "stage_id"], name: "index_user_stars_on_user_id_and_stage_id", unique: true
    t.index ["user_id"], name: "index_user_stars_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.boolean "regular"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "alerts", "stages"
  add_foreign_key "alerts", "users"
  add_foreign_key "stage_details", "stages"
  add_foreign_key "user_stars", "stages"
  add_foreign_key "user_stars", "users"
end
