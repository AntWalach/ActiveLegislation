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

ActiveRecord::Schema[7.1].define(version: 2024_11_16_225643) do
  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bill_committees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "bill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_committees_on_bill_id"
  end

  create_table "bills", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.integer "status"
    t.boolean "gdpr_consent", default: false, null: false
    t.boolean "privacy_policy", default: false, null: false
    t.boolean "public_disclosure_consent", default: false, null: false
    t.text "current_state"
    t.text "proposed_changes"
    t.text "expected_effects"
    t.text "funding_sources"
    t.text "implementation_guidelines"
    t.boolean "eu_compliance", default: false
    t.text "eu_remarks"
    t.index ["category"], name: "index_bills_on_category"
    t.index ["status"], name: "index_bills_on_status"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "committee_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "bill_committee_id", null: false
    t.bigint "user_id", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_committee_id"], name: "index_committee_members_on_bill_committee_id"
    t.index ["user_id"], name: "index_committee_members_on_user_id"
  end

  create_table "committee_signatures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "bill_committee_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_committee_id"], name: "index_committee_signatures_on_bill_committee_id"
    t.index ["user_id"], name: "index_committee_signatures_on_user_id"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "address"
    t.string "postal_code"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "petition_id"
    t.bigint "petition_comment_id"
    t.index ["petition_comment_id"], name: "index_notifications_on_petition_comment_id"
    t.index ["petition_id"], name: "index_notifications_on_petition_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "petition_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "petition_id"
    t.bigint "official_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment_type"
    t.index ["official_id"], name: "index_petition_comments_on_official_id"
    t.index ["petition_id"], name: "index_petition_comments_on_petition_id"
  end

  create_table "petition_views", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "petition_id"
    t.bigint "user_id"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["petition_id"], name: "index_petition_views_on_petition_id"
    t.index ["user_id"], name: "index_petition_views_on_user_id"
  end

  create_table "petitions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.integer "signatures_count", default: 0
    t.integer "petition_type"
    t.bigint "grouped_petition_id"
    t.boolean "published", default: false
    t.text "updates"
    t.string "third_party_name"
    t.string "third_party_address"
    t.bigint "department_id"
    t.datetime "deadline"
    t.bigint "assigned_official_id"
    t.integer "views", default: 0
    t.index ["assigned_official_id"], name: "index_petitions_on_assigned_official_id"
    t.index ["department_id"], name: "index_petitions_on_department_id"
    t.index ["grouped_petition_id"], name: "index_petitions_on_grouped_petition_id"
    t.index ["user_id"], name: "index_petitions_on_user_id"
  end

  create_table "signatures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "petition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bill_id"
    t.index ["bill_id"], name: "index_signatures_on_bill_id"
    t.index ["petition_id"], name: "index_signatures_on_petition_id"
    t.index ["user_id"], name: "index_signatures_on_user_id"
  end

  create_table "taggings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.string "official_role"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bill_committees", "bills"
  add_foreign_key "bills", "users"
  add_foreign_key "committee_members", "bill_committees"
  add_foreign_key "committee_members", "users"
  add_foreign_key "committee_signatures", "bill_committees"
  add_foreign_key "committee_signatures", "users"
  add_foreign_key "notifications", "petition_comments"
  add_foreign_key "notifications", "petitions"
  add_foreign_key "notifications", "users"
  add_foreign_key "petition_comments", "petitions"
  add_foreign_key "petition_comments", "users", column: "official_id"
  add_foreign_key "petition_views", "petitions"
  add_foreign_key "petition_views", "users"
  add_foreign_key "petitions", "departments"
  add_foreign_key "petitions", "petitions", column: "grouped_petition_id"
  add_foreign_key "petitions", "users"
  add_foreign_key "petitions", "users", column: "assigned_official_id"
  add_foreign_key "signatures", "bills"
  add_foreign_key "signatures", "petitions"
  add_foreign_key "signatures", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "departments"
end
