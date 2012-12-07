FactoryGirl.define do
  factory :order_item, class: "InventoryItem" do
    association :shipping_box
    association :inventory_item
    association :inventory_entry
  end
end
