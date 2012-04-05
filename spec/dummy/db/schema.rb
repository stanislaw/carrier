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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110814164229) do

  create_table "chains", :force => true do |t|
    t.string   "participants",      :default => "--- []\n"
    t.string   "archived_for",      :default => "--- []\n"
    t.integer  "having_chain_id"
    t.string   "having_chain_type"
    t.string   "chain_type",        :default => "--- :simple\n...\n"
    t.integer  "messages_count",    :default => 0
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "chains", ["archived_for", "participants"], :name => "participants_and_archived_index"
  add_index "chains", ["created_at"], :name => "index_chains_on_created_at"
  add_index "chains", ["having_chain_id", "having_chain_type"], :name => "having_index"

  create_table "messages", :force => true do |t|
    t.integer  "sender"
    t.string   "recipients", :default => "--- []\n"
    t.string   "subject"
    t.text     "content"
    t.boolean  "last",       :default => false
    t.integer  "chain_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "messages", ["chain_id"], :name => "index_messages_on_chain_id"
  add_index "messages", ["created_at"], :name => "index_messages_on_created_at"

  create_table "posts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "read_marks", :force => true do |t|
    t.integer  "readable_id"
    t.integer  "user_id",                     :null => false
    t.string   "readable_type", :limit => 20, :null => false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], :name => "index_read_marks_on_user_id_and_readable_type_and_readable_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "username"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
