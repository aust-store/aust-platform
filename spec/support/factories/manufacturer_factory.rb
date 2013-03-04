FactoryGirl.define do
  factory :manufacturer do
    sequence(:name) { |i| "Manufacturer ##{i}" }
    association :company
  end
end
