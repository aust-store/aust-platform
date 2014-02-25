# PRODUCTION DATA
  Role.where(name: "customer").first_or_create!
  Role.where(name: "supplier").first_or_create!

  # Themes
  Theme.where(path: "overblue").first_or_create!(name: "Overblue", public: true)
  Theme.where(path: "flat_pink").first_or_create!(name: "Flat Pink", public: true)
  Theme.where(path: "minimalism").first_or_create!(name: "Minimalism", vertical_taxonomy_menu: true, public: true)
    # private
    Theme.where(path: "private/gladini").first_or_create!(name: "Gladini", vertical_taxonomy_menu: true, public: false)

  SuperAdminUser.first_or_create(email: "superadmin@example.com", password: "123456")


# DEVELOPMENT DATA
  if Rails.env.development?
    require "factory_girl_rails"
    Dir[Rails.root.join("spec/support/factories/*.rb")].each { |f| require f }

    store = Company.where(handle: "mystore").first_or_create(name: "My Store")
    Inventory.where(company_id: store.id).first_or_create
    admin = AdminUser.where(email: "admin@example.com")
              .first_or_create(password: "123456",
                               name:     "Alexandre",
                               role:     "founder",
                               company_id: store.id)
    #puts FactoryGirl.attributes_for(:inventory_item, company: store, user: admin)
  end
