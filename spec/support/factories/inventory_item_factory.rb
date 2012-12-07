FactoryGirl.define do
  factory :inventory_item_without_entries, class: "InventoryItem" do
    association :user, factory: :admin_user
    association :shipping_box
    sequence(:name) { |i| "Goodyear tire 4 inches ##{i}" }
    description "Lorem ipsum lorem"
    merchandising "The best item ever!!"

    # images
    after(:create) do |item, evaluator|
      FactoryGirl.create_list(:inventory_item_image, 2,
                              inventory_item: item)
    end
  end

  factory :inventory_item_two, parent: :inventory_item do
    sequence(:name) { |i| "Bridgestone tire 5 inches ##{i}" }
    description "Whatever ipsum lorem."
  end

  factory :inventory_item, parent: :inventory_item_without_entries do
    # inventory_entry
    after(:create) do |item, evaluator|
      FactoryGirl.create_list(:inventory_entry, 3,
                              inventory_item: item,
                              store: evaluator.company)
    end

    factory :inventory_item_with_company do
      association :company
    end
  end
end
