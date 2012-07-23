Factory.define :inventory_entry, class: InventoryEntry do |f|
  f.description "These came from Japan."
  f.quantity 4
  f.cost_per_unit 20.0
  f.balance_type "in"
  f.moving_average_cost 20.0
  f.total_quantity 4
  f.total_cost 100.0
  f.association :good
  f.association :admin_user
end

Factory.define :inventory_entry_lite, class: InventoryEntry do |f|
  f.description "These came from Japan."
  f.quantity 4
  f.cost_per_unit 20.0
  f.association :good
  f.association :admin_user
end
