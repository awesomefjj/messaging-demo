# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_20_093143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notification_events", force: :cascade do |t|
    t.integer "kind", null: false
    t.string "title"
    t.string "content"
    t.string "redirect_url"
    t.jsonb "extra_data"
    t.integer "created_by"
    t.integer "notifications_count", default: 0, null: false
    t.integer "read_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by"], name: "index_notification_events_on_created_by"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "tenant_id"
    t.string "receiver_type"
    t.string "receiver_id"
    t.integer "kind", null: false
    t.string "title"
    t.string "content"
    t.string "redirect_url"
    t.integer "status", default: 0, null: false
    t.integer "event_id"
    t.json "extra_data"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_notifications_on_event_id"
    t.index ["receiver_type", "receiver_id"], name: "index_notifications_on_receiver_type_and_receiver_id"
    t.index ["tenant_id"], name: "index_notifications_on_tenant_id"
  end

end
