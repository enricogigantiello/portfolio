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

ActiveRecord::Schema[8.1].define(version: 2026_03_24_084752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.string "chat_type", default: "generic", null: false
    t.datetime "created_at", null: false
    t.bigint "model_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["chat_type"], name: "index_chats_on_chat_type"
    t.index ["model_id"], name: "index_chats_on_model_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "educations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "degree"
    t.text "description"
    t.date "end_date"
    t.decimal "grade"
    t.decimal "grade_max"
    t.decimal "grade_min"
    t.string "institution"
    t.integer "position"
    t.date "start_date"
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date"
    t.integer "position"
    t.string "role"
    t.date "start_date"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level"
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "cache_creation_tokens"
    t.integer "cached_tokens"
    t.bigint "chat_id", null: false
    t.text "content"
    t.json "content_raw"
    t.datetime "created_at", null: false
    t.integer "input_tokens"
    t.bigint "model_id"
    t.integer "output_tokens"
    t.string "role", null: false
    t.text "thinking_signature"
    t.text "thinking_text"
    t.integer "thinking_tokens"
    t.bigint "tool_call_id"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["model_id"], name: "index_messages_on_model_id"
    t.index ["role"], name: "index_messages_on_role"
    t.index ["tool_call_id"], name: "index_messages_on_tool_call_id"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.string "locale", null: false
    t.bigint "translatable_id"
    t.string "translatable_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.string "locale", null: false
    t.bigint "translatable_id"
    t.string "translatable_type"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "models", force: :cascade do |t|
    t.jsonb "capabilities", default: []
    t.integer "context_window"
    t.datetime "created_at", null: false
    t.string "family"
    t.date "knowledge_cutoff"
    t.integer "max_output_tokens"
    t.jsonb "metadata", default: {}
    t.jsonb "modalities", default: {}
    t.datetime "model_created_at"
    t.string "model_id", null: false
    t.string "name", null: false
    t.jsonb "pricing", default: {}
    t.string "provider", null: false
    t.datetime "updated_at", null: false
    t.index ["capabilities"], name: "index_models_on_capabilities", using: :gin
    t.index ["family"], name: "index_models_on_family"
    t.index ["modalities"], name: "index_models_on_modalities", using: :gin
    t.index ["provider", "model_id"], name: "index_models_on_provider_and_model_id", unique: true
    t.index ["provider"], name: "index_models_on_provider"
  end

  create_table "portfolio_documents", force: :cascade do |t|
    t.string "chunk_type"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.vector "embedding", limit: 1536
    t.jsonb "metadata", default: {}
    t.bigint "source_id"
    t.string "source_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["embedding"], name: "index_portfolio_documents_on_embedding", opclass: :vector_cosine_ops, using: :hnsw
    t.index ["source_type", "source_id", "chunk_type"], name: "index_portfolio_documents_on_source_and_chunk_type", unique: true
    t.index ["source_type", "source_id"], name: "index_portfolio_documents_on_source_type_and_source_id"
  end

  create_table "profile_achievements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_profile_achievements_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name", default: "", null: false
    t.string "linkedin_url"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "website_url"
  end

  create_table "project_achievements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position"
    t.bigint "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_achievements_on_project_id"
  end

  create_table "project_teches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position"
    t.bigint "project_id", null: false
    t.bigint "tech_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_teches_on_project_id"
    t.index ["tech_id"], name: "index_project_teches_on_tech_id"
  end

  create_table "projects", force: :cascade do |t|
    t.jsonb "commit_counts"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "job_id", null: false
    t.integer "position"
    t.string "role"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_projects_on_job_id"
  end

  create_table "reference_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "favicon"
    t.string "image"
    t.string "label"
    t.string "link_type"
    t.integer "position"
    t.bigint "referenceable_id"
    t.string "referenceable_type"
    t.jsonb "thumbnail_data"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["referenceable_type", "referenceable_id"], name: "idx_on_referenceable_type_referenceable_id_baab57da9e"
    t.index ["referenceable_type", "referenceable_id"], name: "index_reference_links_unique_job", unique: true, where: "((referenceable_type)::text = 'Job'::text)"
  end

  create_table "tech_categories", force: :cascade do |t|
    t.string "category_type"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "teches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "tech_category_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tech_category_id"], name: "index_teches_on_tech_category_id"
  end

  create_table "tool_calls", force: :cascade do |t|
    t.jsonb "arguments", default: {}
    t.datetime "created_at", null: false
    t.bigint "message_id", null: false
    t.string "name", null: false
    t.string "thought_signature"
    t.string "tool_call_id", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_tool_calls_on_message_id"
    t.index ["name"], name: "index_tool_calls_on_name"
    t.index ["tool_call_id"], name: "index_tool_calls_on_tool_call_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "models"
  add_foreign_key "chats", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "models"
  add_foreign_key "messages", "tool_calls"
  add_foreign_key "profile_achievements", "profiles"
  add_foreign_key "project_achievements", "projects"
  add_foreign_key "project_teches", "projects"
  add_foreign_key "project_teches", "teches"
  add_foreign_key "projects", "jobs"
  add_foreign_key "teches", "tech_categories"
  add_foreign_key "tool_calls", "messages"
end
