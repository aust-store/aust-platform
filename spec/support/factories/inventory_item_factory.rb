FactoryGirl.define do
  factory :inventory_item_without_associations, class: "InventoryItem" do
    sequence(:name) { |i| "Goodyear tire 4 inches ##{i}" }
    description "Lorem ipsum lorem"
    year "2011"
    merchandising "The best item ever!!"
    association :user, factory: :admin_user
    association :company
    association :taxonomy
    association :manufacturer
    association :shipping_box

    factory :inventory_item_for_sale_without_entry do

      # inventory_entry_price
      after(:create) do |item, evaluator|
        FactoryGirl.create(:inventory_item_price,
                           value: "12.34",
                           inventory_item_id: item.id)
      end

      # images
      after(:create) do |item, evaluator|
        item.images << FactoryGirl.build(:inventory_item_cover_image)
        item.images << FactoryGirl.build(:inventory_item_image)
        item.save
      end

      factory :inventory_item_for_sale do
        after(:create) do |item, evaluator|
          FactoryGirl.create(:inventory_entry,
                             inventory_item: item,
                             store_id: item.company.id)
        end
      end

      # this has 3 entries
      factory :inventory_item do
        ignore do
          total_entries 3
        end

        # inventory_entry
        after(:create) do |item, evaluator|
          FactoryGirl.create_list(:inventory_entry, evaluator.total_entries,
                                  inventory_item: item,
                                  store_id: item.company.id,
                                  admin_user_id: item.user.id)
        end
      end
    end
  end
end
