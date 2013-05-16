FactoryGirl.define do
  factory :customer do
    first_name  "Jane"
    last_name  "Doe"
    description  "Rich dude"
    association :company
  end
end
