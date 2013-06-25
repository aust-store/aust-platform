FactoryGirl.define do
  factory :super_admin_user do
    sequence(:email) { |s| "superadmin#{s}@example.com" }
    password "123456"
    password_confirmation "123456"
  end
end
