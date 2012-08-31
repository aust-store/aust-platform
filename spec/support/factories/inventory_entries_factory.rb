FactoryGirl.define do
  factory :inventory_entry do
    description "These came from Japan."
    quantity 4
    cost_per_unit 20.0
    balance_type "in"
    moving_average_cost 20.0
    total_quantity 4
    total_cost 100.0
    #association :store, factory: :company
  end

  factory :inventory_entry_lite, parent: :inventory_entry do
    description "These came from Japan."
    quantity 4
    cost_per_unit 20.0
    association :good
    association :admin_user
  end
end
