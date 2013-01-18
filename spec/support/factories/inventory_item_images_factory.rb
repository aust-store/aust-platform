FactoryGirl.define do
  factory :inventory_item_image, class: "InventoryItemImage" do
    factory :inventory_item_cover_image do
      cover true
    end
  end
end
