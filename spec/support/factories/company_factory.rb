FactoryGirl.define do
  factory :company do
    name { |i| "Super Company ##{i}" }
    association :inventory
    handle { |i| "handle_#{i}" }
  end
end
