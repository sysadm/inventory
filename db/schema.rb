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

ActiveRecord::Schema.define(version: 20150728001617) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "crypted_password",             null: false
    t.string   "salt",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["remember_me_token"], name: "index_admins_on_remember_me_token"

  create_table "backups", force: :cascade do |t|
    t.string   "file"
    t.string   "digest"
    t.integer  "size"
    t.boolean  "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "departments", force: :cascade do |t|
    t.string   "title"
    t.integer  "old_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "archive",    default: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string   "tag"
    t.string   "model"
    t.string   "serial"
    t.text     "notes"
    t.date     "date_of_purchase"
    t.date     "date_of_registration"
    t.integer  "kind_id"
    t.integer  "vendor_id"
    t.integer  "user_id"
    t.integer  "old_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "archive",              default: false
  end

  add_index "inventories", ["kind_id"], name: "index_inventories_on_kind_id"
  add_index "inventories", ["user_id"], name: "index_inventories_on_user_id"
  add_index "inventories", ["vendor_id"], name: "index_inventories_on_vendor_id"

  create_table "kinds", force: :cascade do |t|
    t.text     "description"
    t.integer  "old_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "archive",     default: false
    t.boolean  "mobile",      default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "department_id"
    t.boolean  "login"
    t.boolean  "admin"
    t.integer  "old_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "archive",       default: false
    t.boolean  "read_only",     default: false
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id"

  create_table "vendors", force: :cascade do |t|
    t.string   "title"
    t.string   "address"
    t.string   "contact_person"
    t.string   "email"
    t.string   "phone"
    t.integer  "old_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "archive",        default: false
  end

end
