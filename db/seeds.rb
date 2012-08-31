if Rails.env.development?
  store = Company.find_or_create_by_handle(name: "My Store", handle: "my_store")
  inventory = Inventory.find_or_create_by_company_id(store.id)
  admin = AdminUser.find_or_create_by_email(email: "admin@example.com",
                                            password: "123456",
                                            company_id: store.id)

  item = Good.find_or_create_by_name(name: "T-Shirt Apple",
                                     admin_user_id: admin.id,
                                     company_id: store.id)
  entry = InventoryEntry.create(good_id: item.id,
                                store_id: store.id,
                                admin_user_id: admin.id,
                                balance_type: "in",
                                description: "Create with seed",
                                quantity: 1000,
                                cost_per_unit: 12.0,
                                moving_average_cost: 9.0,
                                total_quantity: 2000,
                                total_cost: 5000)
end
