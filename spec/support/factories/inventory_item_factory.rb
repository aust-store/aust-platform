FactoryGirl.define do
  factory :inventory_item_without_associations, class: "InventoryItem" do
    sequence(:name) { |i| "Goodyear tire 4 inches ##{i}" }
    description "Lorem ipsum lorem"
    merchandising "The best item ever!!"
    association :user, factory: :admin_user
    association :company

    factory :inventory_item do
      association :shipping_box

      # inventory_entry
      after(:create) do |item, evaluator|
        FactoryGirl.create_list(:inventory_entry, 3,
                                inventory_item: item,
                                store: evaluator.company)
      end

      # images
      after(:create) do |item, evaluator|
        item.images << FactoryGirl.build(:inventory_item_cover_image)
        item.images << FactoryGirl.build(:inventory_item_image)
        item.save
      end
    end
  end
end
