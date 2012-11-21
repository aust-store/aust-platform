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

ActiveRecord::Schema.define(:version => 20121109074438) do

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
    t.string   "role"
    t.string   "name"
  end

  add_index "admin_users", ["company_id"], :name => "index_admin_users_on_company_id"
  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "carts", ["company_id"], :name => "index_carts_on_company_id"
  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "handle"
  end

  add_index "companies", ["handle"], :name => "index_companies_on_handle"

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "description"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "customers", ["company_id"], :name => "index_customers_on_company_id"

  create_table "inventories", :force => true do |t|
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "inventory_entries", :force => true do |t|
    t.integer  "inventory_item_id"
    t.integer  "admin_user_id"
    t.string   "balance_type"
    t.text     "description"
    t.decimal  "quantity"
    t.decimal  "cost_per_unit"
    t.decimal  "moving_average_cost"
    t.decimal  "total_quantity"
    t.decimal  "total_cost"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "store_id"
    t.decimal  "price",               :precision => 8, :scale => 2
    t.boolean  "on_sale",                                           :default => true
  end

  add_index "inventory_entries", ["admin_user_id"], :name => "index_good_balances_on_admin_user_id"
  add_index "inventory_entries", ["inventory_item_id"], :name => "index_good_balances_on_good_id"
  add_index "inventory_entries", ["on_sale"], :name => "index_inventory_entries_on_on_sale"
  add_index "inventory_entries", ["store_id"], :name => "index_inventory_entries_on_store_id"

  create_table "inventory_item_images", :force => true do |t|
    t.integer  "inventory_item_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "image"
    t.boolean  "cover",             :default => false
  end

  add_index "inventory_item_images", ["cover"], :name => "index_good_images_on_cover"
  add_index "inventory_item_images", ["inventory_item_id"], :name => "index_good_images_on_good_id"

  create_table "inventory_items", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "inventory_id"
    t.string   "reference"
    t.integer  "admin_user_id"
    t.text     "merchandising"
  end

  add_index "inventory_items", ["company_id"], :name => "index_goods_on_company_id"

  create_table "order_items", :force => true do |t|
    t.integer  "inventory_item_id"
    t.decimal  "price",              :precision => 8, :scale => 2
    t.decimal  "quantity",           :precision => 8, :scale => 2
    t.integer  "inventory_entry_id"
    t.integer  "cart_id"
    t.integer  "order_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "order_items", ["cart_id"], :name => "index_order_items_on_cart_id"
  add_index "order_items", ["inventory_entry_id"], :name => "index_order_items_on_inventory_entry_id"
  add_index "order_items", ["inventory_item_id"], :name => "index_order_items_on_inventory_item_id"
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

end
