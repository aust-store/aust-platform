Factory.define :company do |u|
  u.name { |i| "Super Company" }
  u.association :inventory
  u.handle :my_store
end

