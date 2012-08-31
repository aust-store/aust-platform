FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |s| "user#{s}@example.com" }
    password "1234567"
    association :company
  end
end
