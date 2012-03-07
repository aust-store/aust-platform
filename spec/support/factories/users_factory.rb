Factory.define :admin_user do |u|
  u.sequence(:email) { |s| "user#{s}@example.com" }
  u.password "1234567"
  u.association :company
end
