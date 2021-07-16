# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_16_085345) do

  create_table "events", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "event_id", null: false
    t.text "name", null: false
    t.integer "need_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_bring_items", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.integer "bring_number", null: false
    t.boolean "check", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id", "user_id"], name: "index_user_bring_items_on_item_id_and_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users_events", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.string "event_id", null: false
    t.index ["event_id"], name: "index_users_events_on_event_id"
    t.index ["user_id", "event_id"], name: "index_users_events_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_users_events_on_user_id"
  end

  add_foreign_key "users_events", "events"
  add_foreign_key "users_events", "users"
end
