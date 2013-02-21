FactoryGirl.define do
  factory :inventory_entry do
    description "These came from Japan."
    quantity 8
    cost_per_unit 20.0
    balance_type "in"
    moving_average_cost 20.0
    total_quantity 8
    total_cost 160.0
  end
end
