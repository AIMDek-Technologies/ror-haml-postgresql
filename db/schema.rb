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

ActiveRecord::Schema.define(version: 20151027112233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "house_name"
    t.string   "street"
    t.string   "area"
    t.integer  "user_id"
    t.string   "geographic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bulk_uploads", force: true do |t|
    t.datetime "upload_date"
    t.integer  "time_taken"
    t.integer  "total_records"
    t.integer  "success_count"
    t.integer  "failure_count"
    t.string   "file_name"
    t.string   "error_file_path"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.string   "card_number"
    t.date     "valid_from_date"
    t.date     "valid_to_date"
    t.string   "cvv"
    t.string   "name_on_card"
    t.datetime "statement_date"
    t.integer  "user_id"
    t.float    "credit_limit"
    t.float    "available_credit_limit"
    t.integer  "reward_points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographics", force: true do |t|
    t.string   "zip_code"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statements", force: true do |t|
    t.integer  "credit_card_id"
    t.datetime "statement_date"
    t.datetime "from_date"
    t.datetime "to_date"
    t.float    "amount_due"
    t.string   "file_path"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "credit_card_id"
    t.float    "amount"
    t.datetime "transaction_date"
    t.float    "balance"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "phone_number"
    t.string   "profile_pic_path"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
