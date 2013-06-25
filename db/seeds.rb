if Rails.env.development?
  store = Company.where(handle: "mystore").first_or_create(name: "My Store")
  inventory = Inventory.where(company_id: store.id).first_or_create
  admin = AdminUser.where(email: "admin@example.com")
                   .first_or_create(password: "123456",
                                    name:     "Alexandre",
                                    role:     "founder",
                                    company_id: store.id)
end
