# PRODUCTION DATA
  customer_role = Role.where(name: "customer").first_or_create!
  Role.where(name: "supplier").first_or_create!

  # Themes
  Theme.where(path: "overblue").first_or_create!(name: "Overblue", public: true)
  Theme.where(path: "flat_pink").first_or_create!(name: "Flat Pink", public: true)
  Theme.where(path: "minimalism").first_or_create!(name: "Minimalism", vertical_taxonomy_menu: true, public: true)
    # private
    Theme.where(path: "private/gladini").first_or_create!(name: "Gladini", vertical_taxonomy_menu: true, public: false)

  SuperAdminUser.first_or_create(email: "superadmin@example.com", password: "123456")


# DEVELOPMENT DATA
  require_relative "seeds/pos"
