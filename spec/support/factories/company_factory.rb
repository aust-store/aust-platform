FactoryGirl.define do
  factory :company do
    sequence(:name) { |i| "Super Company ##{i}" }
    association :inventory
    sequence(:handle) { |i| "handle_#{i}" }
  end
end
