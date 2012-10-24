FactoryGirl.define do
  factory :admin_user do
  	name "The Tick"
    sequence(:email) { |s| "user#{s}@example.com" }
    password "1234567"
    association :company
    role "founder"
  end
end