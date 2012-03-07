Factory.define :company do |u|
  u.name { |i| "Super Company" }
  u.association :inventory
end

