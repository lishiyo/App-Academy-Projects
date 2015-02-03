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

ActiveRecord::Schema.define(version: 20141203220741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "text"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_shares", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "favorited",  default: false
  end

  add_index "contact_shares", ["contact_id"], name: "index_contact_shares_on_contact_id", using: :btree
  add_index "contact_shares", ["user_id", "contact_id"], name: "index_contact_shares_on_user_id_and_contact_id", unique: true, using: :btree
  add_index "contact_shares", ["user_id"], name: "index_contact_shares_on_user_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "favorited",  default: false
  end

  add_index "contacts", ["user_id", "email"], name: "index_contacts_on_user_id_and_email", unique: true, using: :btree
  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "group_memberships", force: true do |t|
    t.integer  "group_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["contact_id", "group_id"], name: "index_group_memberships_on_contact_id_and_group_id", unique: true, using: :btree
  add_index "group_memberships", ["contact_id"], name: "index_group_memberships_on_contact_id", using: :btree
  add_index "group_memberships", ["group_id"], name: "index_group_memberships_on_group_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["owner_id"], name: "index_groups_on_owner_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
