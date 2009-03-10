# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080802071628) do

  create_table "bills", :force => true do |t|
    t.string   "name"
    t.decimal  "amount",                    :precision => 10, :scale => 2
    t.integer  "currency_id", :limit => 11
    t.integer  "payer_id",    :limit => 11
    t.integer  "creator_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bills", ["currency_id"], :name => "bill__currency_id"

  create_table "currencies", :force => true do |t|
    t.string "name",                  :limit => 20
    t.string "short_code",            :limit => 4
    t.string "format_options_string"
  end

  create_table "direct_login_identifiers", :force => true do |t|
    t.integer  "identified_person_id", :limit => 11,                    :null => false
    t.integer  "invitor_id",           :limit => 11
    t.string   "code"
    t.boolean  "obsolete",                           :default => false
    t.datetime "created_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "bill_id",        :limit => 11
    t.integer  "participant_id", :limit => 11
    t.integer  "factor",         :limit => 11,                                :default => 1
    t.integer  "creator_id",     :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                       :precision => 10, :scale => 2
    t.integer  "currency_id",    :limit => 11
    t.integer  "payer_id",       :limit => 11
  end

  add_index "participations", ["bill_id"], :name => "participations__bill_id"
  add_index "participations", ["currency_id"], :name => "participations__currency_id"

  create_table "people", :force => true do |t|
    t.string   "email"
    t.integer  "currency_id",               :limit => 11
    t.integer  "level",                     :limit => 11
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
  end

end
