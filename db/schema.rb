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

ActiveRecord::Schema.define(:version => 20130220200955) do

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

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.text     "address_1"
    t.text     "address_2"
    t.text     "city"
    t.text     "zipcode"
    t.string   "state"
    t.string   "country"
    t.boolean  "default"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "neighborhood"
    t.string   "number"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addressable_id_and_addressable_type"
  add_index "addresses", ["default"], :name => "index_addresses_on_default"

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
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "environment"
  end

  add_index "carts", ["company_id"], :name => "index_carts_on_company_id"
  add_index "carts", ["environment"], :name => "index_carts_on_environment"
  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "handle"
    t.text     "domain"
  end

  add_index "companies", ["domain"], :name => "index_companies_on_domain"
  add_index "companies", ["handle"], :name => "index_companies_on_handle"

  create_table "company_settings", :force => true do |t|
    t.integer  "company_id"
    t.hstore   "settings"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "company_settings", ["company_id"], :name => "index_company_settings_on_company_id"
  add_index "company_settings", ["settings"], :name => "company_settings_gist_settings"

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
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "on_sale",             :default => true
    t.integer  "store_id"
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

  create_table "inventory_item_prices", :force => true do |t|
    t.integer  "inventory_item_id"
    t.decimal  "value",             :precision => 8, :scale => 2
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "inventory_item_prices", ["inventory_item_id"], :name => "index_inventory_item_prices_on_inventory_item_id"

  create_table "inventory_item_properties", :force => true do |t|
    t.integer  "inventory_item_id"
    t.hstore   "properties"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "inventory_item_properties", ["inventory_item_id"], :name => "index_inventory_item_properties_on_inventory_item_id"
  add_index "inventory_item_properties", ["properties"], :name => "item_properties"

  create_table "inventory_items", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "inventory_id"
    t.string   "reference"
    t.integer  "admin_user_id"
    t.text     "merchandising"
    t.integer  "taxonomy_id"
    t.integer  "year"
    t.integer  "manufacturer_id"
  end

  add_index "inventory_items", ["company_id"], :name => "index_goods_on_company_id"
  add_index "inventory_items", ["manufacturer_id"], :name => "index_inventory_items_on_manufacturer_id"
  add_index "inventory_items", ["taxonomy_id"], :name => "index_inventory_items_on_taxonomy_id"

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "manufacturers", ["company_id"], :name => "index_manufacturers_on_company_id"

  create_table "order_items", :force => true do |t|
    t.integer  "inventory_item_id"
    t.decimal  "price",              :precision => 8, :scale => 2
    t.decimal  "quantity",           :precision => 8, :scale => 2
    t.integer  "inventory_entry_id"
    t.integer  "cart_id"
    t.integer  "order_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "status"
  end

  add_index "order_items", ["cart_id"], :name => "index_order_items_on_cart_id"
  add_index "order_items", ["inventory_entry_id"], :name => "index_order_items_on_inventory_entry_id"
  add_index "order_items", ["inventory_item_id"], :name => "index_order_items_on_inventory_item_id"
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["status"], :name => "index_order_items_on_status"

  create_table "order_shippings", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "order_id"
    t.decimal  "price"
    t.integer  "delivery_days"
    t.text     "delivery_type"
    t.text     "service_type"
    t.text     "zipcode"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "order_shippings", ["cart_id"], :name => "index_order_shippings_on_cart_id"
  add_index "order_shippings", ["order_id"], :name => "index_order_shippings_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "environment"
  end

  add_index "orders", ["cart_id"], :name => "index_orders_on_cart_id"
  add_index "orders", ["environment"], :name => "index_orders_on_environment"
  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "payment_gateways", :force => true do |t|
    t.integer  "store_id"
    t.string   "name"
    t.string   "email"
    t.text     "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "payment_gateways", ["store_id"], :name => "index_payment_gateways_on_store_id"

  create_table "payment_statuses", :force => true do |t|
    t.integer  "order_id"
    t.string   "status"
    t.text     "notification_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "payment_statuses", ["order_id"], :name => "index_payment_statuses_on_order_id"
  add_index "payment_statuses", ["status"], :name => "index_payment_statuses_on_status"

  create_table "shipping_boxes", :force => true do |t|
    t.decimal  "length",            :precision => 8, :scale => 2
    t.decimal  "width",             :precision => 8, :scale => 2
    t.decimal  "height",            :precision => 8, :scale => 2
    t.decimal  "weight",            :precision => 8, :scale => 2
    t.integer  "inventory_item_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "shipping_boxes", ["inventory_item_id"], :name => "index_shipping_boxes_on_inventory_item_id"

  create_table "taxonomies", :force => true do |t|
    t.text     "name"
    t.integer  "parent_id"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "taxonomies", ["parent_id"], :name => "index_taxonomies_on_parent_id"
  add_index "taxonomies", ["store_id"], :name => "index_taxonomies_on_store_id"

  create_table "taxonomy_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "taxonomy_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_taxonomy_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "taxonomy_hierarchies", ["descendant_id"], :name => "index_taxonomy_hierarchies_on_descendant_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "first_name"
    t.text     "last_name"
    t.string   "social_security_number"
    t.string   "nationality"
    t.boolean  "receive_newsletter"
    t.string   "mobile_number"
    t.string   "home_number"
    t.string   "work_number"
    t.string   "home_area_number"
    t.string   "work_area_number"
    t.string   "mobile_area_number"
    t.integer  "store_id"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["receive_newsletter"], :name => "index_users_on_receive_newsletter"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["store_id"], :name => "index_users_on_store_id"

end
