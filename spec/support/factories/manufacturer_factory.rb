FactoryGirl.define do
  factory :manufacturer do
    sequence(:name) { |i| "Manufacturer ##{i}" }
    company :company
  end
end
