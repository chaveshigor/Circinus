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

ActiveRecord::Schema.define(version: 2022_03_13_233532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "hobbies", force: :cascade do |t|
    t.string "name"
    t.bigint "hobby_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hobby_category_id"], name: "index_hobbies_on_hobby_category_id"
  end

  create_table "hobby_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profile_hobbies", force: :cascade do |t|
    t.bigint "profiles_id", null: false
    t.bigint "hobbies_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hobbies_id"], name: "index_profile_hobbies_on_hobbies_id"
    t.index ["profiles_id"], name: "index_profile_hobbies_on_profiles_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.datetime "born"
    t.text "description"
    t.bigint "city_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_profiles_on_city_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "uf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.boolean "account_confirmed", default: false
    t.string "confirmation_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cities", "states"
  add_foreign_key "hobbies", "hobby_categories"
  add_foreign_key "profile_hobbies", "hobbies", column: "hobbies_id"
  add_foreign_key "profile_hobbies", "profiles", column: "profiles_id"
  add_foreign_key "profiles", "cities"
  add_foreign_key "profiles", "users"
end
