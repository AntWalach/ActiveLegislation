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

ActiveRecord::Schema[7.1].define(version: 2024_10_02_213302) do
  create_table "action_text_rich_texts", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bills", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.text "justification"
    t.string "category"
    t.integer "required_signatures", default: 100000
    t.datetime "signatures_deadline"
    t.string "status"
    t.index ["category"], name: "index_bills_on_category"
    t.index ["status"], name: "index_bills_on_status"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "petitions", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.text "comments"
    t.string "category"
    t.string "address"
    t.string "recipient"
    t.text "justification"
    t.integer "signature_goal"
    t.date "end_date"
    t.string "creator_name"
    t.text "public_comment"
    t.string "attachment"
    t.text "external_links"
    t.string "priority"
    t.boolean "gdpr_consent", default: false
    t.boolean "privacy_policy", default: false
    t.string "subcategory"
    t.index ["user_id"], name: "index_petitions_on_user_id"
  end

  create_table "signatures", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "petition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "digital_signature"
    t.index ["petition_id"], name: "index_signatures_on_petition_id"
    t.index ["user_id"], name: "index_signatures_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "disabled", default: false
    t.string "role_mask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "public_key"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "postal_code"
    t.string "city"
    t.string "country"
    t.string "pesel"
    t.string "phone_number"
    t.date "date_of_birth"
    t.boolean "verified", default: false, null: false
    t.string "type"
    t.string "department"
    t.string "office_location"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bills", "users"
  add_foreign_key "petitions", "users"
  add_foreign_key "signatures", "petitions"
  add_foreign_key "signatures", "users"
end
