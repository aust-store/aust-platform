FactoryGirl.define do
  factory :order_item, class: "OrderItem" do
    association :shipping_box
    association :inventory_item
    association :inventory_entry

    price 13.94
    quantity 4
  end
end
