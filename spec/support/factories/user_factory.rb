FactoryGirl.define do
  factory :user do
    sequence(:email) { |s| "user#{s}@example.com" }
    sequence(:first_name) { |s| "The Tick#{n}" }
    sequence(:last_name) { |s| "Holycowjohnson#{n}" }
    password "123456"
    password_confirmation "123456"
    social_security_number "141.482.543-93"
    home_number   "12345678"
    work_number   "12345678"
    mobile_number "12345678"
  end
end
