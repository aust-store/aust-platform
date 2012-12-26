FactoryGirl.define do
  factory :order do
    association :shipping_address, factory: :address
    association :user
    association :company

    # address
    after(:create) do |order, evaluator|
      order.items.build(FactoryGirl.attributes_for(:order_item))
      order.save
    end

    factory :cart, class: "Cart" do

    end
  end
end
