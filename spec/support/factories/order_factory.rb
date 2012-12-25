FactoryGirl.define do
  factory :order do
    association :shipping_address, factory: :address
  end
end
