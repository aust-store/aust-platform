FactoryGirl.define do
  factory :admin_user do
    sequence(:name) { |s| "The Tick#{s}" }
    sequence(:email) { |s| "user#{s}@example.com" }
    password "1234567"
    password_confirmation "1234567"
    association :company
    role "founder"
  end
end
