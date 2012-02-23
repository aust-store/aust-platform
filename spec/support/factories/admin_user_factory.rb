Factory.define :admin_user do |u|
  u.sequence(:email) {|i| "user#{i}@example.com" }
  u.password "123456"
end