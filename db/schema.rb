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

ActiveRecord::Schema[8.0].define(version: 2026_07_29_003549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "artifacts", force: :cascade do |t|
    t.bigint "snapshot_id", null: false
    t.string "name", null: false
    t.integer "artifact_type", null: false
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artifact_type"], name: "index_artifacts_on_artifact_type"
    t.index ["path"], name: "index_artifacts_on_path"
    t.index ["snapshot_id"], name: "index_artifacts_on_snapshot_id"
  end

  create_table "code_artifacts", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.string "path", null: false
    t.string "class_name"
    t.string "superclass"
    t.string "namespace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "artifact_type", null: false
    t.index ["artifact_type"], name: "index_code_artifacts_on_artifact_type"
    t.index ["class_name"], name: "index_code_artifacts_on_class_name"
    t.index ["full_name"], name: "index_code_artifacts_on_full_name"
    t.index ["path"], name: "index_code_artifacts_on_path"
    t.index ["repository_id"], name: "index_code_artifacts_on_repository_id"
  end

  create_table "commit_files", force: :cascade do |t|
    t.bigint "commit_id", null: false
    t.string "path", null: false
    t.integer "change_type", null: false
    t.integer "additions", default: 0
    t.integer "deletions", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commit_id"], name: "index_commit_files_on_commit_id"
    t.index ["path"], name: "index_commit_files_on_path"
  end

  create_table "commits", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.string "sha", null: false
    t.string "author_name"
    t.string "author_email"
    t.text "message"
    t.datetime "committed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "architecture_change", default: false, null: false
    t.json "change_summary", default: {}
    t.index ["committed_at"], name: "index_commits_on_committed_at"
    t.index ["repository_id"], name: "index_commits_on_repository_id"
    t.index ["sha"], name: "index_commits_on_sha"
  end

  create_table "features", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.string "name", null: false
    t.integer "feature_type", null: false
    t.bigint "first_commit_id"
    t.bigint "last_commit_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_commit_id"], name: "index_features_on_first_commit_id"
    t.index ["last_commit_id"], name: "index_features_on_last_commit_id"
    t.index ["name"], name: "index_features_on_name"
    t.index ["repository_id"], name: "index_features_on_repository_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "github_url", null: false
    t.string "default_branch"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_url"], name: "index_projects_on_github_url", unique: true
  end

  create_table "repositories", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "local_path"
    t.string "default_branch"
    t.string "head_sha"
    t.integer "commit_count", default: 0
    t.integer "repository_size", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_repositories_on_project_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "commit_id", null: false
    t.datetime "captured_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["captured_at"], name: "index_snapshots_on_captured_at"
    t.index ["commit_id"], name: "index_snapshots_on_commit_id"
    t.index ["repository_id"], name: "index_snapshots_on_repository_id"
  end

  add_foreign_key "artifacts", "snapshots"
  add_foreign_key "code_artifacts", "repositories"
  add_foreign_key "commit_files", "commits"
  add_foreign_key "commits", "repositories"
  add_foreign_key "features", "commits", column: "first_commit_id"
  add_foreign_key "features", "commits", column: "last_commit_id"
  add_foreign_key "features", "repositories"
  add_foreign_key "repositories", "projects"
  add_foreign_key "snapshots", "commits"
  add_foreign_key "snapshots", "repositories"
end
