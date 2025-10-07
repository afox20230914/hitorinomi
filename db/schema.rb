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

ActiveRecord::Schema.define(version: 2025_10_07_122239) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "store_id", null: false
    t.text "body"
    t.integer "good_count", default: 0
    t.integer "bad_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "deleted"
    t.index ["store_id"], name: "index_comments_on_store_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "store_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_favorites_on_store_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "name"
    t.string "postal_code"
    t.string "prefecture"
    t.string "city"
    t.string "address_detail"
    t.time "opening_time"
    t.time "closing_time"
    t.string "seating_capacity"
    t.string "store_type"
    t.string "smoking_allowed"
    t.text "holidays"
    t.integer "budget", default: 1000
    t.text "description", limit: 500
    t.boolean "is_owner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "postal_code"
    t.string "prefecture"
    t.string "city"
    t.string "address_detail"
    t.time "opening_time"
    t.time "closing_time"
    t.string "seating_capacity"
    t.string "store_type"
    t.string "smoking_allowed"
    t.text "holidays"
    t.integer "budget"
    t.text "description"
    t.string "main_image_1"
    t.string "main_image_2"
    t.string "main_image_3"
    t.string "main_image_4"
    t.text "interior_images"
    t.text "exterior_images"
    t.text "food_images"
    t.text "menu_images"
    t.integer "user_id"
    t.boolean "is_owner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "post_id"
    t.index ["post_id"], name: "index_stores_on_post_id"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "last_name", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.date "birth_date", default: "2000-01-01", null: false
    t.string "username", default: "", null: false
    t.text "profile"
    t.boolean "is_account_public", default: true
    t.boolean "is_visit_public", default: true
    t.boolean "is_deleted", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.integer "user_id"
    t.integer "store_id"
    t.datetime "visited_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "stores"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "stores"
  add_foreign_key "favorites", "users"
  add_foreign_key "stores", "posts"
  add_foreign_key "stores", "users"
end
