FactoryGirl.define do
  factory :good do
    association :user, factory: :admin_user
    name { |i| "Goodyear tire 4 inches ##{i}" }
    description "Lorem ipsum lorem"

    after(:create) do |good, evaluator|
      FactoryGirl.create_list(:inventory_entry, 2,
                              good: good,
                              store: evaluator.company)
    end

    factory :good_with_company do
      association :company
    end
  end

  factory :good_two, parent: :good do
    name { |i| "Bridgestone tire 5 inches ##{i}" }
    description "Whatever ipsum lorem."
  end
end
