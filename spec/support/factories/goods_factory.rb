Factory.define :good do |u|
  u.association :company
  u.association :user, factory: :admin_user
  u.name { |i| "Goodyear tire 4 inches" }
  u.description "Lorem ipsum lorem"
end

Factory.define :good_two, parent: :good do |u|
  u.name { |i| "Bridgestone tire 5 inches" }
  u.description "Whatever ipsum lorem."
end
