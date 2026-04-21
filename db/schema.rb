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

ActiveRecord::Schema[8.1].define(version: 2026_04_18_061361) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "flow_versions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.jsonb "definition_json", default: {}, null: false
    t.bigint "flow_id", null: false
    t.datetime "published_at"
    t.datetime "updated_at", null: false
    t.integer "version_number", null: false
    t.index ["created_by_id"], name: "index_flow_versions_on_created_by_id"
    t.index ["flow_id", "version_number"], name: "index_flow_versions_on_flow_id_and_version_number", unique: true
    t.index ["flow_id"], name: "index_flow_versions_on_flow_id"
    t.index ["published_at"], name: "index_flow_versions_on_published_at"
  end

  create_table "flows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["status"], name: "index_flows_on_status"
    t.index ["workspace_id", "name"], name: "index_flows_on_workspace_id_and_name"
    t.index ["workspace_id"], name: "index_flows_on_workspace_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.jsonb "config_json", default: {}, null: false
    t.datetime "created_at", null: false
    t.bigint "flow_version_id", null: false
    t.string "key", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_version_id", "key"], name: "index_steps_on_flow_version_id_and_key", unique: true
    t.index ["flow_version_id", "position"], name: "index_steps_on_flow_version_id_and_position"
    t.index ["flow_version_id"], name: "index_steps_on_flow_version_id"
    t.index ["type"], name: "index_steps_on_type"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workspace_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role", default: "member", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.index ["role"], name: "index_workspace_memberships_on_role"
    t.index ["user_id"], name: "index_workspace_memberships_on_user_id"
    t.index ["workspace_id", "user_id"], name: "index_workspace_memberships_on_workspace_id_and_user_id", unique: true
    t.index ["workspace_id"], name: "index_workspace_memberships_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_workspaces_on_owner_id"
  end

  add_foreign_key "flow_versions", "flows"
  add_foreign_key "flow_versions", "users", column: "created_by_id"
  add_foreign_key "flows", "workspaces"
  add_foreign_key "sessions", "users"
  add_foreign_key "steps", "flow_versions"
  add_foreign_key "workspace_memberships", "users"
  add_foreign_key "workspace_memberships", "workspaces"
  add_foreign_key "workspaces", "users", column: "owner_id"
end
