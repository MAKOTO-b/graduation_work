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

ActiveRecord::Schema[7.2].define(version: 2025_10_24_040418) do
  create_table "grumbles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.integer "likes_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_grumbles_on_user_id"
  end

  create_table "likes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "grumble_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grumble_id"], name: "index_likes_on_grumble_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "rmd_chat_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "rmd_chat_room_id", null: false
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "partner_id"
    t.boolean "is_read", default: false, null: false
    t.index ["rmd_chat_room_id"], name: "index_rmd_chat_messages_on_rmd_chat_room_id"
    t.index ["user_id"], name: "index_rmd_chat_messages_on_user_id"
  end

  create_table "rmd_chat_room_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "rmd_chat_room_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rmd_chat_room_id"], name: "index_rmd_chat_room_users_on_rmd_chat_room_id"
    t.index ["user_id"], name: "index_rmd_chat_room_users_on_user_id"
  end

  create_table "rmd_chat_rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "profile_image"
    t.integer "matching_status", default: 0, null: false
    t.string "provider"
    t.string "uid"
    t.string "google_name"
    t.integer "chatbot_messages_count", default: 0, null: false
    t.date "chatbot_messages_count_on"
    t.datetime "last_active_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "grumbles", "users"
  add_foreign_key "likes", "grumbles"
  add_foreign_key "likes", "users"
  add_foreign_key "rmd_chat_messages", "rmd_chat_rooms"
  add_foreign_key "rmd_chat_messages", "users"
  add_foreign_key "rmd_chat_room_users", "rmd_chat_rooms"
  add_foreign_key "rmd_chat_room_users", "users"
end
