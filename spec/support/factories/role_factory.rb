FactoryGirl.define do
  factory :role do
    name "customer"

    trait :customer do
      name "customer"
    end

    trait :supplier do
      name "supplier"
    end
  end
end
