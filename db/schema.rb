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

ActiveRecord::Schema[7.2].define(version: 2024_09_04_111013) do
  create_table "injections", force: :cascade do |t|
    t.float "dose_mm"
    t.string "lot_number", limit: 6
    t.string "drug_name"
    t.date "date"
    t.integer "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_number", "drug_name", "date"], name: "index_injections_on_lot_number_and_drug_name_and_date", unique: true
    t.index ["patient_id"], name: "index_injections_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.date "date_of_birth"
    t.string "api_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_patients_on_email", unique: true
    t.index ["id", "api_key"], name: "index_patients_on_id_and_api_key", unique: true
  end

  add_foreign_key "injections", "patients"
end
