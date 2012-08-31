FactoryGirl.define do
  factory :account_receivable do
    association :company
    association :customer
    association :admin_user, factory: :admin_user
    value 500.0
    description "Lorem ipsum lorem"
    due_to "1987/04/21"
  end
end
