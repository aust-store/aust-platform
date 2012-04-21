Factory.define :account_receivable do |u|
  u.association :company
  u.association :customer
  u.association :admin_user, factory: :admin_user
  u.value 500.0
  u.description "Lorem ipsum lorem"
  u.due_to "1987/04/21"
end
