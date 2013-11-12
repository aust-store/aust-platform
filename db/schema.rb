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

ActiveRecord::Schema.define(version: 20131112022336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.text     "address_1"
    t.text     "address_2"
    t.text     "city"
    t.text     "zipcode"
    t.string   "state"
    t.string   "country"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "neighborhood"
    t.string   "number"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree
  add_index "addresses", ["default"], name: "index_addresses_on_default", using: :btree

  create_table "admin_dashboards", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "role"
    t.string   "name"
  end

  add_index "admin_users", ["company_id"], name: "index_admin_users_on_company_id", using: :btree
  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "banners", force: true do |t|
    t.integer  "company_id"
    t.string   "image"
    t.string   "title"
    t.string   "url"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banners", ["company_id"], name: "index_banners_on_company_id", using: :btree

  create_table "carts", force: true do |t|
    t.integer  "customer_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "environment"
  end

  add_index "carts", ["company_id"], name: "index_carts_on_company_id", using: :btree
  add_index "carts", ["customer_id"], name: "index_carts_on_customer_id", using: :btree
  add_index "carts", ["environment"], name: "index_carts_on_environment", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle"
    t.text     "domain"
    t.integer  "theme_id"
  end

  add_index "companies", ["domain"], name: "index_companies_on_domain", using: :btree
  add_index "companies", ["handle"], name: "index_companies_on_handle", using: :btree
  add_index "companies", ["theme_id"], name: "index_companies_on_theme_id", using: :btree

  create_table "company_settings", force: true do |t|
    t.integer  "company_id"
    t.hstore   "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_settings", ["company_id"], name: "index_company_settings_on_company_id", using: :btree
  add_index "company_settings", ["settings"], name: "company_settings_gist_settings", using: :gist

  create_table "contacts", force: true do |t|
    t.string   "phone_1"
    t.string   "phone_2"
    t.string   "email"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["contactable_id"], name: "index_contacts_on_contactable_id", using: :btree
  add_index "contacts", ["contactable_type"], name: "index_contacts_on_contactable_type", using: :btree

  create_table "customers", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "customers", ["authentication_token"], name: "index_customers_on_authentication_token", unique: true, using: :btree
  add_index "customers", ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true, using: :btree
  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["receive_newsletter"], name: "index_customers_on_receive_newsletter", using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree
  add_index "customers", ["store_id"], name: "index_customers_on_store_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "inventories", force: true do |t|
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventory_entries", force: true do |t|
    t.integer  "inventory_item_id"
    t.integer  "admin_user_id"
    t.text     "description"
    t.decimal  "quantity"
    t.decimal  "cost_per_unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
    t.boolean  "on_sale",           default: true
  end

  add_index "inventory_entries", ["admin_user_id"], name: "index_inventory_entries_on_admin_user_id", using: :btree
  add_index "inventory_entries", ["inventory_item_id"], name: "index_inventory_entries_on_inventory_item_id", using: :btree
  add_index "inventory_entries", ["on_sale"], name: "index_inventory_entries_on_on_sale", using: :btree
  add_index "inventory_entries", ["store_id"], name: "index_inventory_entries_on_store_id", using: :btree

  create_table "inventory_item_images", force: true do |t|
    t.integer  "inventory_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "cover",             default: false
  end

  add_index "inventory_item_images", ["cover"], name: "index_inventory_item_images_on_cover", using: :btree
  add_index "inventory_item_images", ["inventory_item_id"], name: "index_inventory_item_images_on_inventory_item_id", using: :btree

  create_table "inventory_item_prices", force: true do |t|
    t.integer  "inventory_item_id"
    t.decimal  "value",             precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventory_item_prices", ["inventory_item_id"], name: "index_inventory_item_prices_on_inventory_item_id", using: :btree

  create_table "inventory_item_properties", force: true do |t|
    t.integer  "inventory_item_id"
    t.hstore   "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventory_item_properties", ["inventory_item_id"], name: "index_inventory_item_properties_on_inventory_item_id", using: :btree
  add_index "inventory_item_properties", ["properties"], name: "item_properties", using: :gin

  create_table "inventory_items", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
    t.string   "reference"
    t.integer  "admin_user_id"
    t.text     "merchandising"
    t.integer  "taxonomy_id"
    t.integer  "year"
    t.integer  "manufacturer_id"
    t.decimal  "moving_average_cost", precision: 8, scale: 2
    t.string   "slug"
  end

  add_index "inventory_items", ["company_id"], name: "index_inventory_items_on_company_id", using: :btree
  add_index "inventory_items", ["manufacturer_id"], name: "index_inventory_items_on_manufacturer_id", using: :btree
  add_index "inventory_items", ["slug"], name: "index_inventory_items_on_slug", using: :btree
  add_index "inventory_items", ["taxonomy_id"], name: "index_inventory_items_on_taxonomy_id", using: :btree

  create_table "manufacturers", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_user_id"
  end

  add_index "manufacturers", ["admin_user_id"], name: "index_manufacturers_on_admin_user_id", using: :btree
  add_index "manufacturers", ["company_id"], name: "index_manufacturers_on_company_id", using: :btree

  create_table "order_items", force: true do |t|
    t.integer  "inventory_item_id"
    t.decimal  "price",              precision: 8, scale: 2
    t.decimal  "quantity",           precision: 8, scale: 2
    t.integer  "inventory_entry_id"
    t.integer  "cart_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "parent_id"
  end

  add_index "order_items", ["cart_id"], name: "index_order_items_on_cart_id", using: :btree
  add_index "order_items", ["inventory_entry_id"], name: "index_order_items_on_inventory_entry_id", using: :btree
  add_index "order_items", ["inventory_item_id"], name: "index_order_items_on_inventory_item_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["parent_id"], name: "index_order_items_on_parent_id", using: :btree
  add_index "order_items", ["status"], name: "index_order_items_on_status", using: :btree

  create_table "order_shippings", force: true do |t|
    t.integer  "cart_id"
    t.integer  "order_id"
    t.decimal  "price"
    t.integer  "delivery_days"
    t.text     "delivery_type"
    t.text     "service_type"
    t.text     "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "package_width"
    t.integer  "package_height"
    t.integer  "package_length"
    t.decimal  "package_weight", precision: 8, scale: 2
  end

  add_index "order_shippings", ["cart_id"], name: "index_order_shippings_on_cart_id", using: :btree
  add_index "order_shippings", ["order_id"], name: "index_order_shippings_on_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "cart_id"
    t.integer  "customer_id"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "environment"
  end

  add_index "orders", ["cart_id"], name: "index_orders_on_cart_id", using: :btree
  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["environment"], name: "index_orders_on_environment", using: :btree
  add_index "orders", ["store_id"], name: "index_orders_on_store_id", using: :btree

  create_table "pages", force: true do |t|
    t.text     "title"
    t.text     "body"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_user_id"
  end

  add_index "pages", ["admin_user_id"], name: "index_pages_on_admin_user_id", using: :btree
  add_index "pages", ["company_id"], name: "index_pages_on_company_id", using: :btree

  create_table "payment_gateways", force: true do |t|
    t.integer  "store_id"
    t.string   "name"
    t.string   "email"
    t.text     "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_gateways", ["store_id"], name: "index_payment_gateways_on_store_id", using: :btree

  create_table "payment_statuses", force: true do |t|
    t.integer  "order_id"
    t.string   "status"
    t.text     "notification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_statuses", ["order_id"], name: "index_payment_statuses_on_order_id", using: :btree
  add_index "payment_statuses", ["status"], name: "index_payment_statuses_on_status", using: :btree

  create_table "shipping_boxes", force: true do |t|
    t.decimal  "length",            precision: 8, scale: 2
    t.decimal  "width",             precision: 8, scale: 2
    t.decimal  "height",            precision: 8, scale: 2
    t.decimal  "weight",            precision: 8, scale: 2
    t.integer  "inventory_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipping_boxes", ["inventory_item_id"], name: "index_shipping_boxes_on_inventory_item_id", using: :btree

  create_table "super_admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "super_admin_users", ["email"], name: "index_super_admin_users_on_email", unique: true, using: :btree
  add_index "super_admin_users", ["reset_password_token"], name: "index_super_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "taxonomies", force: true do |t|
    t.text     "name"
    t.integer  "parent_id"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "taxonomies", ["parent_id"], name: "index_taxonomies_on_parent_id", using: :btree
  add_index "taxonomies", ["slug"], name: "index_taxonomies_on_slug", using: :btree
  add_index "taxonomies", ["store_id"], name: "index_taxonomies_on_store_id", using: :btree

  create_table "taxonomy_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "taxonomy_hierarchies", ["ancestor_id", "descendant_id"], name: "index_taxonomy_hierarchies_on_ancestor_id_and_descendant_id", unique: true, using: :btree
  add_index "taxonomy_hierarchies", ["descendant_id"], name: "index_taxonomy_hierarchies_on_descendant_id", using: :btree

  create_table "themes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "path"
    t.boolean  "public",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "vertical_taxonomy_menu", default: false
  end

  add_index "themes", ["company_id"], name: "index_themes_on_company_id", using: :btree

end
