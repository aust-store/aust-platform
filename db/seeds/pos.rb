if Rails.env.development?
  customer_role = Role.where(name: "customer").first
  raise "Missing customer role" unless customer_role.present?

  store = Company.where(handle: "mystore").first_or_create(name: "My Store")
  Inventory.where(company_id: store.id).first_or_create
  admin = AdminUser.where(email: "admin@example.com")
            .first_or_create(password: "123456",
                             name:     "Alexandre",
                             role:     "founder",
                             company_id: store.id)
  puts "My Store (#{store.handle} subdomain),       user email: admin@example.com, password: 123456"
  #puts FactoryGirl.attributes_for(:inventory_item, company: store, user: admin)
end

# POS data
if Rails.env.development? || Rails.env.test?
  store = Company.where(handle: "aust-pos-test").first_or_create(name: "Aust POS test")
  Inventory.where(company_id: store.id).first_or_create
  admin = AdminUser.where(email: "admin@pos.com")
                   .first_or_create(password:   "123456",
                                    name:       "POS admin",
                                    role:       "founder",
                                    company_id: store.id)
  puts "POS test (#{store.handle} subdomain), user email: admin@pos.com,     password: 123456"

  customer = Person.where(
    email: 'customer-pos@aust.com'
  ).first_or_create!(
    first_name: "John",
    last_name: "Rambo",
    environment: "website",
    password: "123456",
    password_confirmation: "123456",
    social_security_number: "141.482.543-93",
    home_number: "1111111",
    home_area_number: "53",
    store: store
  )

  role = PersonRole.where(
    person_id: customer.id,
    role_id: customer_role.id
  ).first_or_create!

  nike = Manufacturer.where(company: store, name: "Nike").first_or_create
  vestuario = store.taxonomies.where(name: "Vestuário").first_or_create
  camiseta  = store.taxonomies.where(name: "Camisetas", parent_id: vestuario.id).first_or_create
  camisas   = store.taxonomies.where(name: "Camisas",   parent_id: vestuario.id).first_or_create

  calcados = store.taxonomies.where(name: "Calçados").first_or_create
  tenis    = store.taxonomies.where(name: "Tênis",   parent_id: calcados.id).first_or_create
  sapatos  = store.taxonomies.where(name: "Sapatos", parent_id: calcados.id).first_or_create

  airmax = InventoryItem.where(company_id:    store.id,
                               taxonomy:      tenis,
                               manufacturer:  nike,
                               name:          "Airmax",
                               description:   "Lorem ipsum lorem",
                               year:          "2014",
                               barcode:       "123",
                               merchandising: "The best",
                               admin_user_id: admin.id,
                               reference_number: "ref123")
                        .first_or_create(tag_list: ["used"])
  puts "Product for #{store.handle}: #{airmax.inspect}"
  InventoryItemPrice.create(inventory_item_id: airmax.id,
                            value: 193,
                            for_installments: 202)
  airmax_entry = InventoryEntry.create(inventory_item: airmax,
                                       description: "These came from Japan",
                                       quantity: 12_000,
                                       cost_per_unit: 150,
                                       point_of_sale: true,
                                       on_sale: true)
  # online order
  Order.create(store: store,
               environment: :website,
               payment_type: "cash",
               total: (193 * 2),
               customer_id: customer.id,
               admin_user_id: admin.id)
  OrderItem.create(price: (193 * 2),
                   quantity: 2,
                   price_for_installments: (202 * 2),
                   inventory_item:  airmax,
                   inventory_entry: airmax_entry)
  # offline order
  cart = Cart.create(company: store,
                     environment: :offline,
                     customer_id: customer.id)

  Order.create(store: store,
               environment: :offline,
               cart_id: cart.id,
               payment_type: "cash",
               total: (193 * 2),
               customer_id: customer.id,
               admin_user_id: admin.id)
  OrderItem.create(price: (193 * 2),
                   quantity: 2,
                   price_for_installments: (202 * 2),
                   inventory_item:  airmax,
                   inventory_entry: airmax_entry)
end
