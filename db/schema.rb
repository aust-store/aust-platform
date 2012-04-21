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

<<<<<<< HEAD
ActiveRecord::Schema.define(:version => 20120417020928) do

  create_table "account_receivables", :force => true do |t|
    t.integer  "company_id"
    t.integer  "admin_user_id"
    t.integer  "customer_id"
    t.decimal  "value"
    t.text     "description"
    t.date     "due_to"
    t.boolean  "paid"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "account_receivables", ["admin_user_id"], :name => "index_account_receivables_on_admin_user_id"
  add_index "account_receivables", ["company_id"], :name => "index_account_receivables_on_company_id"
  add_index "account_receivables", ["customer_id"], :name => "index_account_receivables_on_customer_id"
=======
ActiveRecord::Schema.define(:version => 20120415000914) do
>>>>>>> d16e738... configured uploads for goods

  create_table "admin_dashboards", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_users", :force => true do |t|
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
    t.string   "password_salt"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "company_id"
  end

  add_index "admin_users", ["company_id"], :name => "index_admin_users_on_company_id"
  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "description"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "customers", ["company_id"], :name => "index_customers_on_company_id"

  create_table "good_balances", :force => true do |t|
    t.integer  "good_id"
    t.integer  "admin_user_id"
    t.string   "balance_type"
    t.text     "description"
    t.decimal  "quantity"
    t.decimal  "cost_per_unit"
    t.decimal  "moving_average_cost"
    t.decimal  "total_quantity"
    t.decimal  "total_cost"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "good_balances", ["admin_user_id"], :name => "index_good_balances_on_admin_user_id"
  add_index "good_balances", ["good_id"], :name => "index_good_balances_on_good_id"

  create_table "good_images", :force => true do |t|
    t.integer  "good_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "good_images", ["good_id"], :name => "index_good_images_on_good_id"

  create_table "goods", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "inventory_id"
    t.string   "reference"
    t.integer  "admin_user_id"
    t.string   "image"
  end

  add_index "goods", ["company_id"], :name => "index_goods_on_company_id"

  create_table "inventories", :force => true do |t|
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
