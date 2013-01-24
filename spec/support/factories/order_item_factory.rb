FactoryGirl.define do
  factory :order_item_without_associations, class: "OrderItem" do
    price 13.94
    quantity 4

    factory :order_item do
      association :shipping_box
      association :inventory_item
      association :inventory_entry
    end
  end
end
