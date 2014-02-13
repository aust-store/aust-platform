FactoryGirl.define do
  factory :custom_field do
    sequence(:name) { |i| "Field X#{i}" }
    related_type "InventoryItem"
  end
end
