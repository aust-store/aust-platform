if Rails.env.development?
  store = Company.find_or_create_by_handle(name: "My Store", handle: "mystore")
  inventory = Inventory.find_or_create_by_company_id(store.id)
  admin = AdminUser.find_or_create_by_email(email:    "admin@example.com",
                                            password: "123456",
                                            name:     "Alexandre",
                                            role:     "founder",
                                            company_id: store.id)
end
