# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161027132445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"

  create_table "accounts", force: :cascade do |t|
    t.string   "username"
    t.string   "email",                  default: "", null: false
    t.string   "slug"
    t.hstore   "properties"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.hstore   "devis"
    t.integer  "sign_in_count"
    t.datetime "confirmation_sent_at"
    t.datetime "reset_password_sent_at"
  end

  add_index "accounts", ["authentication_token"], name: "index_accounts_on_authentication_token", unique: true, using: :btree
  add_index "accounts", ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true, using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["properties"], name: "accounts_properties", using: :gin
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  add_index "accounts", ["slug"], name: "index_accounts_on_slug", unique: true, using: :btree
  add_index "accounts", ["username"], name: "index_accounts_on_username", unique: true, using: :btree

  create_table "core_datacast_outputs", force: :cascade do |t|
    t.string   "datacast_identifier", null: false
    t.text     "output"
    t.text     "fingerprint"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "core_datacast_outputs", ["datacast_identifier"], name: "index_core_datacast_outputs_on_datacast_identifier", unique: true, using: :btree

  create_table "core_datacasts", force: :cascade do |t|
    t.integer  "core_project_id"
    t.string   "name"
    t.string   "identifier"
    t.hstore   "properties"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "params_object",          default: {}
    t.json     "column_properties",      default: {}
    t.datetime "last_run_at"
    t.datetime "last_data_changed_at"
    t.integer  "count_of_queries"
    t.float    "average_execution_time"
    t.float    "size"
    t.string   "slug"
    t.string   "table_name"
  end

  add_index "core_datacasts", ["core_project_id"], name: "core_datacasts_core_project_id", using: :btree
  add_index "core_datacasts", ["identifier"], name: "index_core_datacasts_on_identifier", unique: true, using: :btree

  create_table "core_permissions", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "role"
    t.string   "email"
    t.string   "status"
    t.datetime "invited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_owner_team"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "core_project_id"
  end

  add_index "core_permissions", ["account_id"], name: "core_permissions_account_id", using: :btree
  add_index "core_permissions", ["core_project_id"], name: "core_permissions_core_project_id", using: :btree
  add_index "core_permissions", ["email"], name: "index_core_permissions_on_email", using: :btree

  create_table "core_projects", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "slug"
    t.hstore   "properties"
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "core_projects", ["account_id"], name: "core_projects_account_id", using: :btree
  add_index "core_projects", ["properties"], name: "projects_properties", using: :gin
  add_index "core_projects", ["slug"], name: "index_core_projects_on_slug", using: :btree

  create_table "core_session_impls", force: :cascade do |t|
    t.string   "session_id"
    t.integer  "account_id"
    t.string   "ip"
    t.string   "device"
    t.string   "browser"
    t.text     "blurb"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "core_viz_id"
  end

  add_index "core_session_impls", ["account_id"], name: "index_core_session_impls_on_account_id", using: :btree
  add_index "core_session_impls", ["core_viz_id"], name: "core_session_impls_core_viz_id", using: :btree
  add_index "core_session_impls", ["session_id"], name: "index_core_session_impls_on_session_id", unique: true, using: :btree

  create_table "core_sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_sessions", ["session_id"], name: "index_core_sessions_on_session_id", unique: true, using: :btree
  add_index "core_sessions", ["updated_at"], name: "index_core_sessions_on_updated_at", using: :btree

  create_table "core_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "html_content"
    t.string   "genre"
    t.json     "required_variables", default: {}
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "core_themes", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.integer  "sort_order"
    t.json     "config"
    t.text     "image_url"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_themes", ["account_id"], name: "core_themes_account_id", using: :btree

  create_table "core_time_aggregations", force: :cascade do |t|
    t.string   "aggregation_level"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.string   "aggregation_level_value"
    t.string   "metric"
    t.integer  "value"
    t.integer  "difference_from_previous_value"
    t.boolean  "is_positive_value"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "aggregation_index"
    t.string   "aggregation_value_to_display"
  end

  add_index "core_time_aggregations", ["parent_type", "parent_id"], name: "parent_type_parent_id_index", using: :btree

  create_table "core_vizs", force: :cascade do |t|
    t.integer  "core_project_id"
    t.hstore   "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.json     "config"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "ref_chart_combination_code"
    t.string   "core_datacast_identifier"
    t.boolean  "filter_present"
    t.boolean  "is_autogenerated",           default: false
  end

  add_index "core_vizs", ["core_datacast_identifier"], name: "index_core_vizs_on_core_datacast_identifier", using: :btree
  add_index "core_vizs", ["core_project_id"], name: "core_vizs_core_project_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "impl_aggregation_data_sets", force: :cascade do |t|
    t.integer  "impl_aggregation_id"
    t.integer  "impl_data_set_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "impl_aggregation_data_sets", ["impl_aggregation_id", "impl_data_set_id"], name: "impl_aggregation_data_sets_index", using: :btree

  create_table "impl_aggregation_datacasts", force: :cascade do |t|
    t.integer  "impl_aggregation_id"
    t.string   "core_datacast_identifier"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "impl_aggregation_datacasts", ["impl_aggregation_id", "core_datacast_identifier"], name: "index_impl_aggregation_id_core_datacast_identifier_on_impl_aggr", using: :btree

  create_table "impl_aggregation_relations", force: :cascade do |t|
    t.integer  "impl_parent_id"
    t.string   "impl_parent_genre"
    t.integer  "impl_child_id"
    t.string   "impl_child_genre"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "impl_aggregation_relations", ["impl_child_id", "impl_child_genre"], name: "impl_aggregation_relations_child_index", using: :btree
  add_index "impl_aggregation_relations", ["impl_parent_id", "impl_parent_genre"], name: "impl_aggregation_relations_index", using: :btree

  create_table "impl_aggregations", force: :cascade do |t|
    t.integer  "core_project_id"
    t.string   "genre"
    t.string   "name"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "status"
    t.string   "error_messages"
    t.hstore   "properties"
    t.date     "last_updated_at"
  end

  add_index "impl_aggregations", ["core_project_id"], name: "impl_aggregations_core_project_id", using: :btree
  add_index "impl_aggregations", ["genre"], name: "impl_aggregation_genre_index", using: :btree

  create_table "impl_blacklist_datasets", force: :cascade do |t|
    t.string   "dataset"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impl_datasets", force: :cascade do |t|
    t.string   "data_set_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "status"
    t.string   "error_messages"
    t.integer  "impl_aggregation_id"
    t.string   "name"
  end

  add_index "impl_datasets", ["impl_aggregation_id"], name: "impl_data_sets_aggregation_index", using: :btree

  create_table "impl_outputs", force: :cascade do |t|
    t.string   "genre"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "impl_parent_type"
    t.integer  "impl_parent_id"
    t.string   "status"
    t.string   "error_messages"
    t.string   "key"
    t.string   "value"
    t.hstore   "properties"
  end

  add_index "impl_outputs", ["genre"], name: "impl_outputs_genre_index", using: :btree
  add_index "impl_outputs", ["impl_parent_id", "impl_parent_type"], name: "impl_parent_index", using: :btree

  create_table "impl_reports", force: :cascade do |t|
    t.integer  "impl_aggregation_id"
    t.integer  "core_template_id"
    t.string   "name"
    t.string   "slug"
    t.text     "html_content"
    t.json     "variable_object"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_autogenerated",       default: false
    t.integer  "core_project_id",        default: 1
    t.string   "impl_aggregation_genre"
  end

  add_index "impl_reports", ["core_project_id"], name: "impl_reports_core_project_id", using: :btree
  add_index "impl_reports", ["core_template_id"], name: "impl_reports_core_template_id", using: :btree
  add_index "impl_reports", ["impl_aggregation_id"], name: "impl_reports_impl_aggregation_id", using: :btree
  add_index "impl_reports", ["slug"], name: "index_impl_report_on_slug_for_europeana", where: "((impl_aggregation_genre)::text = 'europeana'::text)", using: :btree
  add_index "impl_reports", ["slug"], name: "index_impl_report_on_slug_for_manual_reports", where: "(impl_aggregation_genre IS NULL)", using: :btree
  add_index "impl_reports", ["slug"], name: "index_impl_reports_on_slug_for_country", where: "((impl_aggregation_genre)::text = 'country'::text)", using: :btree
  add_index "impl_reports", ["slug"], name: "index_impl_reports_on_slug_for_data_provider", where: "((impl_aggregation_genre)::text = 'data_provider'::text)", using: :btree
  add_index "impl_reports", ["slug"], name: "index_impl_reports_on_slug_for_provider", where: "((impl_aggregation_genre)::text = 'provider'::text)", using: :btree

  create_table "ref_charts", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.text    "img_small"
    t.string  "genre"
    t.text    "map"
    t.text    "api"
    t.integer "created_by"
    t.integer "updated_by"
    t.string  "img_data_mapping"
    t.string  "slug"
    t.string  "combination_code", limit: 6
    t.string  "source"
    t.string  "file_path"
    t.integer "sort_order"
  end

  add_index "ref_charts", ["combination_code"], name: "ref_charts_index", using: :btree

  create_table "ref_country_codes", force: :cascade do |t|
    t.string   "country"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ref_country_codes", ["country"], name: "ref_country_codes_index", using: :btree

end
