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

ActiveRecord::Schema.define(:version => 20110601143509) do

  create_table "messages_ma_chains", :force => true do |t|
    t.string   "participants",      :default => "--- []\n\n"
    t.string   "archived_for",      :default => "--- []\n\n"
    t.integer  "having_chain_id"
    t.string   "having_chain_type"
    t.string   "chain_type",        :default => "--- :simple\n"
    t.integer  "messages_count",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages_ma_chains", ["archived_for", "participants"], :name => "participants_and_archived_index"
  add_index "messages_ma_chains", ["created_at"], :name => "index_messages_ma_chains_on_created_at"
  add_index "messages_ma_chains", ["having_chain_id", "having_chain_type"], :name => "having_index"

  create_table "messages_ma_messages", :force => true do |t|
    t.integer  "from"
    t.string   "to",           :default => "--- []\n\n"
    t.string   "subject"
    t.string   "message_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chain_id"
  end

  add_index "messages_ma_messages", ["chain_id"], :name => "index_messages_ma_messages_on_chain_id"
  add_index "messages_ma_messages", ["created_at"], :name => "index_messages_ma_messages_on_created_at"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
