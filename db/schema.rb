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

ActiveRecord::Schema[7.0].define(version: 2025_05_30_001433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "character_quest_progresses", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "quest_id", null: false
    t.integer "current_step"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quest_status", default: 0, null: false
    t.json "step_order"
    t.boolean "reward_given"
    t.index ["character_id"], name: "index_character_quest_progresses_on_character_id"
    t.index ["quest_id"], name: "index_character_quest_progresses_on_quest_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.integer "level"
    t.integer "experience"
    t.integer "health", default: 10
    t.integer "strength", default: 10
    t.integer "available_points"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instinct", default: 10
    t.string "avatar"
    t.integer "weapon_id"
    t.integer "top_id"
    t.integer "bottom_id"
    t.integer "accessory_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "combats", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "npc_id", null: false
    t.boolean "won"
    t.integer "character_remaining_hp"
    t.integer "npc_remaining_hp"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "turn"
    t.string "status"
    t.bigint "quest_step_id", null: false
    t.text "log"
    t.index ["character_id"], name: "index_combats_on_character_id"
    t.index ["npc_id"], name: "index_combats_on_npc_id"
    t.index ["quest_step_id"], name: "index_combats_on_quest_step_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.string "equipment_type"
    t.integer "bonus_force"
    t.integer "bonus_pv"
    t.integer "bonus_xp"
    t.integer "bonus_instinct"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "equipment_id"
    t.boolean "equipped", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_inventory_items_on_character_id"
    t.index ["equipment_id"], name: "index_inventory_items_on_equipment_id"
  end

  create_table "npcs", force: :cascade do |t|
    t.string "name"
    t.integer "health"
    t.integer "strength"
    t.bigint "quest_step_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_step_id"], name: "index_npcs_on_quest_step_id"
  end

  create_table "quest_steps", force: :cascade do |t|
    t.bigint "quest_id", null: false
    t.text "description"
    t.boolean "has_riddle"
    t.boolean "has_combat"
    t.integer "step_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "step_type"
    t.integer "base_experience"
    t.index ["quest_id"], name: "index_quest_steps_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "active"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reward_experience"
    t.index ["creator_id"], name: "index_quests_on_creator_id"
  end

  create_table "riddles", force: :cascade do |t|
    t.text "question"
    t.string "correct_answer"
    t.text "wrong_answers"
    t.bigint "quest_step_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_step_id"], name: "index_riddles_on_quest_step_id"
  end

  create_table "step_attempts", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "quest_step_id", null: false
    t.integer "attempt_count"
    t.string "result"
    t.string "choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_step_attempts_on_character_id"
    t.index ["quest_step_id"], name: "index_step_attempts_on_quest_step_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.boolean "is_gamemaster"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_character_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "character_quest_progresses", "characters"
  add_foreign_key "character_quest_progresses", "quests"
  add_foreign_key "characters", "users"
  add_foreign_key "combats", "characters"
  add_foreign_key "combats", "npcs"
  add_foreign_key "combats", "quest_steps"
  add_foreign_key "inventory_items", "characters"
  add_foreign_key "inventory_items", "equipment"
  add_foreign_key "npcs", "quest_steps"
  add_foreign_key "quest_steps", "quests"
  add_foreign_key "quests", "users", column: "creator_id"
  add_foreign_key "riddles", "quest_steps"
  add_foreign_key "step_attempts", "characters"
  add_foreign_key "step_attempts", "quest_steps"
end
