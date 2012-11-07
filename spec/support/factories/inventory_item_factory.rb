FactoryGirl.define do
  factory :inventory_item do
    association :user, factory: :admin_user
    sequence(:name) { |i| "Goodyear tire 4 inches ##{i}" }
    description "Lorem ipsum lorem"

    # inventory_entry
    after(:create) do |item, evaluator|
      FactoryGirl.create_list(:inventory_entry, 2,
                              inventory_item: item,
                              store: evaluator.company)
    end

    # images
    after(:create) do |item, evaluator|
      FactoryGirl.create_list(:inventory_item_image, 2,
                              inventory_item: item)
    end

    factory :inventory_item_with_company do
      association :company
    end

  end

  factory :inventory_item_two, parent: :inventory_item do
    sequence(:name) { |i| "Bridgestone tire 5 inches ##{i}" }
    description "Whatever ipsum lorem."
  end
end
