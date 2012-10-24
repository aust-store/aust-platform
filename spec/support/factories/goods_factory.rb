FactoryGirl.define do
  factory :good do
    association :user, factory: :admin_user
    sequence(:name) { |i| "Goodyear tire 4 inches ##{i}" }
    description "Lorem ipsum lorem"

    # inventory_entry
    after(:create) do |good, evaluator|
      FactoryGirl.create_list(:inventory_entry, 2,
                              good: good,
                              store: evaluator.company)
    end

    # images
    after(:create) do |good, evaluator|
      FactoryGirl.create_list(:item_image, 2,
                              good: good)
    end

    factory :good_with_company do
      association :company
    end

  end

  factory :good_two, parent: :good do
    sequence(:name) { |i| "Bridgestone tire 5 inches ##{i}" }
    description "Whatever ipsum lorem."
  end
end
