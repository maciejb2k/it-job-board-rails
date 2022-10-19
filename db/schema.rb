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

ActiveRecord::Schema[7.0].define(version: 2022_10_13_095156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "candidate_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "photo"
    t.string "location", null: false
    t.string "seniority", null: false
    t.string "status", null: false
    t.string "specialization", null: false
    t.string "position", null: false
    t.integer "salary_from"
    t.integer "salary_to"
    t.string "currency"
    t.boolean "hide_salary", default: false, null: false
    t.string "industry"
    t.string "carrer_path"
    t.string "technology"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_candidates_on_confirmation_token", unique: true
    t.index ["email"], name: "index_candidates_on_email", unique: true
    t.index ["reset_password_token"], name: "index_candidates_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_candidates_on_uid_and_provider", unique: true
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_employers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_employers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employers_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_employers_on_uid_and_provider", unique: true
  end

  create_table "job_application_statuses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_application_id", null: false
    t.index ["job_application_id", "status"], name: "index_job_application_statuses_unique", unique: true
    t.index ["job_application_id"], name: "index_job_application_statuses_on_job_application_id"
  end

  create_table "job_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "cv", null: false
    t.jsonb "data", default: {}
    t.string "note"
    t.string "work_form", null: false
    t.string "city", null: false
    t.string "contract", null: false
    t.string "start_time", null: false
    t.string "working_hours", null: false
    t.datetime "closed_at", precision: nil
    t.boolean "starred", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.uuid "candidate_id"
    t.index ["candidate_id"], name: "index_job_applications_on_candidate_id"
    t.index ["data"], name: "index_job_applications_on_data", using: :gin
    t.index ["job_offer_id"], name: "index_job_applications_on_job_offer_id"
  end

  create_table "job_benefits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "group", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.index ["job_offer_id"], name: "index_job_benefits_on_job_offer_id"
  end

  create_table "job_companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "logo", null: false
    t.integer "size", default: 0, null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.index ["data"], name: "index_job_companies_on_data", using: :gin
    t.index ["job_offer_id"], name: "index_job_companies_on_job_offer_id"
  end

  create_table "job_contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.index ["job_offer_id"], name: "index_job_contacts_on_job_offer_id"
  end

  create_table "job_contracts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "employment", null: false
    t.boolean "hide_salary", default: false, null: false
    t.decimal "from", precision: 8, scale: 2, null: false
    t.decimal "to", precision: 8, scale: 2, null: false
    t.string "currency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.boolean "paid_vacation", default: false, null: false
    t.string "payment_period", null: false
    t.index ["job_offer_id"], name: "index_job_contracts_on_job_offer_id"
  end

  create_table "job_equipment", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "computer", null: false
    t.integer "monitor", default: 1, null: false
    t.boolean "linux", default: false, null: false
    t.boolean "mac_os", default: false, null: false
    t.boolean "windows", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.index ["job_offer_id"], name: "index_job_equipment_on_job_offer_id"
  end

  create_table "job_languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "proficiency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.boolean "required", default: false, null: false
    t.index ["job_offer_id"], name: "index_job_languages_on_job_offer_id"
  end

  create_table "job_locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "city", null: false
    t.string "street", null: false
    t.string "building_number", null: false
    t.string "zip_code", null: false
    t.string "country", null: false
    t.string "country_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.index ["job_offer_id"], name: "index_job_locations_on_job_offer_id"
  end

  create_table "job_offers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "seniority", null: false
    t.text "body", default: "", null: false
    t.datetime "valid_until", precision: nil, null: false
    t.string "rodo"
    t.integer "remote", default: 0, null: false
    t.boolean "interview_online", default: true, null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "category_id", null: false
    t.uuid "technology_id", null: false
    t.boolean "is_active", default: true, null: false
    t.string "slug", null: false
    t.string "travelling", null: false
    t.boolean "ua_supported", default: false, null: false
    t.uuid "employer_id", null: false
    t.string "external_link"
    t.index ["category_id"], name: "index_job_offers_on_category_id"
    t.index ["data"], name: "index_job_offers_on_data", using: :gin
    t.index ["employer_id"], name: "index_job_offers_on_employer_id"
    t.index ["technology_id"], name: "index_job_offers_on_technology_id"
  end

  create_table "job_skills", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", null: false
    t.boolean "optional", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "job_offer_id", null: false
    t.index ["job_offer_id"], name: "index_job_skills_on_job_offer_id"
    t.index ["name"], name: "index_job_skills_on_name"
  end

  create_table "technologies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "job_application_statuses", "job_applications"
  add_foreign_key "job_applications", "candidates"
  add_foreign_key "job_applications", "job_offers"
  add_foreign_key "job_benefits", "job_offers"
  add_foreign_key "job_companies", "job_offers"
  add_foreign_key "job_contacts", "job_offers"
  add_foreign_key "job_contracts", "job_offers"
  add_foreign_key "job_equipment", "job_offers"
  add_foreign_key "job_languages", "job_offers"
  add_foreign_key "job_locations", "job_offers"
  add_foreign_key "job_offers", "categories"
  add_foreign_key "job_offers", "employers"
  add_foreign_key "job_offers", "technologies"
  add_foreign_key "job_skills", "job_offers"
end
